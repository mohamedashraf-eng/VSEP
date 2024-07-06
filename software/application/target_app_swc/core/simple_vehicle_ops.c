/**
******************************************************************************
* @file           : simple_vehicle_ops.c
* @brief          : simple_vehicle_ops implementation file
******************************************************************************
* @attention
*
* All rights reserved.
* CF4A
* Copyright (c) 2023 Neoprimalists
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
******************************************************************************
*/
/*
* =============================================================================
* Project              : CF4A
* Platform             : ARM
* Peripheral           : STM32F103
* SW Version           : 1.0.0
* =============================================================================
*/
/** @defgroup Bootloader libs */
#include "simple_vehicle_ops.h"
/** @defgroup ST libs */
#include "main.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"
#include "rtc.h"

/** @defgroup STD Libs */
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
/* ****************************************************************** */

/* ****************************************************************** */

#define __BTL_COMM_ST_UART_HANDLE huart1
#define __LOG_ST_UART_HANDLE huart2
#define __TIM3_HANDLE htim3

#define BOOTLOADER_START_ADDR         ((uint32)(0x08000000UL))

#define __WRITE_FLAG_APP_TO_BL_ADDR(_FV) HAL_RTCEx_BKUPWrite(&hrtc, __FLAG_APP_TO_BL_ADDR, _FV)
#define __READ_FLAG_APP_TO_BL_ADDR()     HAL_RTCEx_BKUPRead(&hrtc, __FLAG_APP_TO_BL_ADDR)
#define __FLAG_APP_TO_BL_ADDR     RTC_BKP_DR3

/**
 * @defgroup Communication
 * 
 * @todo
 *      1. Prepare UART1 to handle the incoming msg [RESET SIGNAL] to jump to bootloader
 *      2. Character '#' received => DeInit application, Jump to 0 Address [Bootloader]
 */
__STATIC __NORETURN __vJumpToBootloader(void) {
    __disable_irq();
    /* Pre Init Jump */
    memset((uint32*)NVIC->ICER, 0xFF, sizeof(NVIC->ICER));
    SysTick->CTRL = 0;
    SCB->ICSR |= SCB_ICSR_PENDSTCLR_Msk;
    memset((uint32*)NVIC->ICPR, 0xFF, sizeof(NVIC->ICPR));
    /* Load Vector Table */
    SCB->VTOR = (uint32)(BOOTLOADER_START_ADDR);
    /* Read the data stored in the first 4 bytes (Main Stack Pointer) */
    uint32 local_u32MspValue = *((uint32 volatile *)(BOOTLOADER_START_ADDR));
    /* Read the next 4 bytes from the base address (Reset Handler Function) */
    uint32 local_u32ResetHandler = *((uint32 volatile *)(BOOTLOADER_START_ADDR + 4u));
    /* Set the reset handler as function */
#ifdef DIRECT_BOOTLOADER_JUMP
    __NORETURN (*local_vAppResetFunc)(void) = (void*)local_u32ResetHandler;
#endif /* DIRECT_BOOTLOADER_JUMP */
    /* Set the MSP for the application */
    __set_MSP(local_u32MspValue);
    /* Set stack pointer */
    __set_CONTROL(0);
    /* Activate APP_TO_BL flag */
    __WRITE_FLAG_APP_TO_BL_ADDR(TRUE);
    /* Reset clock before start */
    HAL_RCC_DeInit();

    /* Call the reset function to start the application */
#ifdef DIRECT_BOOTLOADER_JUMP
    local_vAppResetFunc();
#else
    HAL_NVIC_SystemReset();
#endif /* DIRECT_BOOTLOADER_JUMP */
}

static uint8 rx_data = 0;

__NORETURN start_gp_procedure(void);
__NORETURN stop_gp_procedure(void);

__NORETURN HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if( (&huart1 == huart) ) {
        switch(rx_data) {
            case '#': __vJumpToBootloader(); break;
            case 's': start_gp_procedure();  break;
            case 'S': stop_gp_procedure();   break;
            default: break;
        }
        HAL_UART_Receive_IT(&huart1, &rx_data, 1u);
    }
}

#ifdef DBG
# define __DBG_SEND_OVER_X(__BUFFER, __LEN) HAL_UART_Transmit(&huart2, (uint8*)(&__BUFFER[0]), (uint16)(__LEN), HAL_MAX_DELAY)
# define DBG_BUFFER_MAX_SIZE ( (uint8) (128) )

#define SEND_LOG(_fmt, ...) send_log(_fmt "\r\n", ##__VA_ARGS__)

__NORETURN static send_log(const uint8* restrict pArg_u8StrFormat, ...) {
    __STATIC uint8 local_u8DbgBuffer[DBG_BUFFER_MAX_SIZE];

    va_list args;
    va_start(args, pArg_u8StrFormat);
    vsnprintf((char *)local_u8DbgBuffer, DBG_BUFFER_MAX_SIZE, (char *)pArg_u8StrFormat, args);
    va_end(args);

    __DBG_SEND_OVER_X(local_u8DbgBuffer, strlen((const char *)local_u8DbgBuffer));
}
#else
# define SEND_LOG(_fmt, ...)
#endif /* DBG */

/**
 * @defgroup Motors 
 * 
 * @todo
 *      1. Make functions to control each motor in car [FL, FR, BL, BR]
 *      2. Make function to stop all motors at once
 *
 */
#define COMMON_PWM_MOTOR_SPEED_O_PORT    (GPIOA) 
#define COMMON_PWM_MOTOR_SPEED_O_PIN     (TIM_CHANNEL_2) 

#define MOTOR_1_PIN_E       (COMMON_PWM_MOTOR_SPEED_O_PIN)
#define MOTOR_2_PIN_E       (COMMON_PWM_MOTOR_SPEED_O_PIN)
#define MOTOR_3_PIN_E       (COMMON_PWM_MOTOR_SPEED_O_PIN)
#define MOTOR_4_PIN_E       (COMMON_PWM_MOTOR_SPEED_O_PIN)

__FORCE_INLINE
__NORETURN ControlMotorFR(uint16 speed) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_1_PIN_E, speed);
}

__FORCE_INLINE
__NORETURN ControlMotorFL(uint16 speed) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_2_PIN_E, speed);
}

__FORCE_INLINE
__NORETURN ControlMotorBR(uint16 speed) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_3_PIN_E, speed);
}

__FORCE_INLINE
__NORETURN ControlMotorBL(uint16 speed) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_4_PIN_E, speed);
}

__NORETURN StopAllMotors(void) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_1_PIN_E, 0u);
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_2_PIN_E, 0u);
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_3_PIN_E, 0u);
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, MOTOR_4_PIN_E, 0u);
}

__NORETURN ControlMotorSpeed(uint8 motor, uint8 speed) {
    uint16 cvtd_speed = (uint16)(speed * 553.85f);
    if (speed >= 0 && speed <= 100) {
        switch (motor) {
            case MOTOR_FR:
                ControlMotorFR(cvtd_speed);
                break;
            case MOTOR_FL:
                ControlMotorFL(cvtd_speed);
                break;
            case MOTOR_BR:
                ControlMotorBR(cvtd_speed);
                break;
            case MOTOR_BL:
                ControlMotorBL(cvtd_speed);
                break;
            case MOTOR_ALL:
                if (0u == speed) {
                    StopAllMotors();
                } else {
                    ControlMotorFR(cvtd_speed);
                    ControlMotorFL(cvtd_speed);
                    ControlMotorBR(cvtd_speed);
                    ControlMotorBL(cvtd_speed);
                }
                break;
            default:
                break;
        }
    } else {
        StopAllMotors();
    }
}

/**
 * @defgroup Buzzer 
 * 
 * @todo
 *
 */

#define BUZZER_PIN      (BUZZER_Pin)
#define BUZZER_PORT     (BUZZER_GPIO_Port)  

__FORCE_INLINE
__NORETURN BuzzerUUUUUH(void) {
    // SEND_LOG("Buzzer ON");
    HAL_GPIO_WritePin(BUZZER_PORT, BUZZER_PIN, GPIO_PIN_SET);
}

__FORCE_INLINE
__NORETURN BuzzerNO(void) {
    // SEND_LOG("Buzzer OFF");
    HAL_GPIO_WritePin(BUZZER_PORT, BUZZER_PIN, GPIO_PIN_RESET);
}

/**
 * @defgroup Leds 
 * 
 */

#define LED_FR_PIN      (TIM_CHANNEL_3)
#define LED_FL_PIN      (TIM_CHANNEL_3)

__FORCE_INLINE
__NORETURN ControlLedFR(uint16 intensity) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, LED_FR_PIN, intensity);
}

__FORCE_INLINE
__NORETURN ControlLedFL(uint16 intensity) {
    __HAL_TIM_SET_COMPARE(&__TIM3_HANDLE, LED_FL_PIN, intensity);
}

__NORETURN ControlFrontLeds(uint8 led, uint8 intensity) {
    if( ((intensity >= 0) && (intensity <= 100)) ) {
        uint16 cvtd_intensity = (uint16)(intensity * 553.85f);
        switch(led) {
            case LED_FR : ControlLedFR(cvtd_intensity); break;
            case LED_FL : ControlLedFL(cvtd_intensity); break;
            case LED_ALL:
                ControlLedFR(cvtd_intensity);
                ControlLedFL(cvtd_intensity);
                break;
            default: break;
        }
    }
}

/**
 * @defgroup Ultrasonic 
 * 
 * @todo
 *
 */
static uint8 uss_work_flag = FALSE;

static __NORETURN delay_us(uint16 delay) {
    if (0 != delay) {
        __HAL_TIM_SET_COUNTER(&htim4, 0);
        while (__HAL_TIM_GET_COUNTER(&htim4) < delay);
    }
}

#define DELAY_US(_D) delay_us(_D)
#define DELAY_MS(_D) do {                                            \
                        if (0 != _D) {                               \
                            for (uint16 i = 0; i < 1000u; ++i)     \
                                delay_us(_D);                        \
                        }                                            \
                    } while (0)

#define USS_TRIGGER_PORT    (USS_TRIGGER_GPIO_Port)
#define USS_TRIGGER_PIN     (USS_TRIGGER_Pin)

__FORCE_INLINE
static __NORETURN uss_trigger(void) {
    HAL_GPIO_WritePin(USS_TRIGGER_PORT, USS_TRIGGER_PIN, GPIO_PIN_RESET);
    DELAY_US(10);
    HAL_GPIO_WritePin(USS_TRIGGER_PORT, USS_TRIGGER_PIN, GPIO_PIN_SET);
    DELAY_US(12);
    HAL_GPIO_WritePin(USS_TRIGGER_PORT, USS_TRIGGER_PIN, GPIO_PIN_RESET);

    __HAL_TIM_ENABLE_IT(&htim2, TIM_IT_CC3);
}

static uint8 g_UssDistance = USS_THRESHOLD_DISTANCE_CM + 1u;
static boolean IsFirstCaptured = FALSE;
static uint32 IcuCapturedVal1 = 0;
static uint32 IcuCapturedVal2 = 0;
static uint32 Diff = 0;

#define USS_THRESHOLD_ERROR_MARGIN_CM (9)

__NORETURN HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef *htim) {
    if (htim == &htim2 && htim->Channel == HAL_TIM_ACTIVE_CHANNEL_3) {
        if (!IsFirstCaptured) {
            IcuCapturedVal1 = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_3);
            IsFirstCaptured = TRUE;
            __HAL_TIM_SET_CAPTUREPOLARITY(htim, TIM_CHANNEL_3, TIM_INPUTCHANNELPOLARITY_FALLING);
        } else {
            IcuCapturedVal2 = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_3);
            __HAL_TIM_SET_COUNTER(htim, 0);

            if (IcuCapturedVal2 > IcuCapturedVal1) {
                Diff = (IcuCapturedVal2 - IcuCapturedVal1);
            } else if (IcuCapturedVal2 < IcuCapturedVal1) {
                // Handle timer overflow case
                Diff = (0xFFFFU - IcuCapturedVal1) + IcuCapturedVal2 + 1; // Add 1 to account for timer overflow
            } else {
                // Equal values, should not occur in normal operation
                SEND_LOG("Error: Equal capture values received");
            }

            // Calculate distance based on the pulse duration
            g_UssDistance = (uint8)(0.017 * Diff) + 1U;
            SEND_LOG("g_UssDistance = %d cm", g_UssDistance);

            // Check distance immediately after capturing it
            CheckIfDistanceInValidRange(g_UssDistance);

            IsFirstCaptured = FALSE;
            __HAL_TIM_SET_CAPTUREPOLARITY(htim, TIM_CHANNEL_3, TIM_INPUTCHANNELPOLARITY_RISING);
            __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC3);
        }
    }
}

__FORCE_INLINE
__NORETURN GetUltraSonicDistance(void) {
    uss_trigger();
}

__FORCE_INLINE
__NORETURN BUZZBUZZ(uint8 distance) {
    BuzzerUUUUUH();
}

/**
 * TODO(Wx): Optimize for speed
 * Applied:
 *      1. Forced Inline
 *      2. Less condition making
 *      3. Faster conditions (PParadox Technique)
 * 
 */
__FORCE_INLINE
__NORETURN CheckIfDistanceInValidRange(uint8 distance) {
    static volatile boolean vehicle_stopped = FALSE;

    if (FALSE == uss_work_flag) {
        BuzzerNO();
        return TRUE;
    }

    boolean volatile is_within_threshold = \ 
        (distance <= (USS_THRESHOLD_DISTANCE_CM + USS_THRESHOLD_ERROR_MARGIN_CM));

    if (is_within_threshold != vehicle_stopped) {
        if (is_within_threshold) {
            ControlMotorSpeed(MOTOR_ALL, 0u);
            BUZZBUZZ(distance);
        } else {
            ControlMotorSpeed(MOTOR_ALL, MOTORS_SPEED);
            BuzzerNO();
        }
        vehicle_stopped = is_within_threshold;
    }
}

typedef struct {
    uint16 tone;
    uint16 duration;
} RingtoneStep;

// Nokia ringtone sequence
static RingtoneStep nokiaRingtone[] = {
    {2637, 200},
    {0, 100},
    {2637, 200},
    {0, 100},
    {2637, 200},
    {0, 100},
    {3136, 200},
    {0, 100},
    {2349, 200},
    {0, 100},
    {2217, 200},
    {0, 100},
    {2349, 200},
    {0, 100},
    {0, 500}
};

static __NORETURN buzzer_init(RingtoneStep *ringtone, uint16 steps) {
    for (uint16 i = 0; i < steps; i++) {
        if (ringtone[i].tone == 0) {
            DELAY_MS(25);
        } else {
            BuzzerUUUUUH();
            DELAY_MS(50);
            BuzzerNO();
        }
    }
}

__NORETURN vehicle_init(void) {
    SEND_LOG("\n Starting Application with VTOR: 0x%x", SCB->VTOR);
    __WRITE_FLAG_APP_TO_BL_ADDR(FALSE);

    buzzer_init(nokiaRingtone, sizeof(nokiaRingtone) / sizeof(nokiaRingtone[0]));

    HAL_UART_Receive_IT(&huart1, &rx_data, 1u);
}

__FORCE_INLINE
__NORETURN start_gp_procedure(void) {
    uss_work_flag = TRUE;
    ControlMotorSpeed(MOTOR_ALL, MOTORS_SPEED);
    ControlFrontLeds(LED_ALL, FRONT_LEDS_INTENSITY);
    GetUltraSonicDistance();
}

__FORCE_INLINE
__NORETURN stop_gp_procedure(void) {
    uss_work_flag = FALSE;
    ControlMotorSpeed(MOTOR_ALL, 0);
    ControlFrontLeds(LED_ALL, 0);
}

/**
 * Main application function
 * 
 */
__NORETURN app_main(void) {
    while (1) {
        GetUltraSonicDistance();
        DELAY_MS(50);
    }
}
