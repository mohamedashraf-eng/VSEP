/**
 * @file    startup_stm32f103c8tx.c
 * @brief   This is the startup file for the stm32f103c8tx
 * @author  Mohamed Wx
 * @date    23-05-2024 
 * 
 * @copyright Copyrights (C) 2024, Mohamed Wx
 * 
 * @attention LICENSE: GNU GENERAL PUBLIC LICENSE V3.0
 * 
**/

#include <stdint.h>

/* Linker script defined symbols */
extern uint32_t _sidata; /* Start address for the initialization values of the .data section. */
extern uint32_t _sdata;  /* Start address for the .data section */
extern uint32_t _edata;  /* End address for the .data section */
extern uint32_t _sbss;   /* Start address for the .bss section */
extern uint32_t _ebss;   /* End address for the .bss section */
extern void _estack;     /* End of stack */
extern void main(void);  /* Main function prototype */
void SystemInit(void);   /* CMSIS System Initialization prototype */
void __libc_init_array(void); /* C library initialization array */

/* Define an empty _init function */
void _init(void) {
    // Empty _init function to satisfy the linker.
}

/* Function prototypes */
void Reset_Handler(void);
void Default_Handler(void);
void NMI_Handler(void) __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void MemManage_Handler(void) __attribute__((weak, alias("Default_Handler")));
void BusFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SVC_Handler(void) __attribute__((weak, alias("Default_Handler")));
void DebugMon_Handler(void) __attribute__((weak, alias("Default_Handler")));
void PendSV_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("Default_Handler")));
void WWDG_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void PVD_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TAMPER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RTC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void FLASH_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RCC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI0_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel6_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel7_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void ADC1_2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USB_HP_CAN1_TX_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USB_LP_CAN1_RX0_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void CAN1_RX1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void CAN1_SCE_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI9_5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_BRK_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_UP_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_TRG_COM_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_CC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C1_EV_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C1_ER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C2_EV_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C2_ER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SPI1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SPI2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI15_10_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RTC_Alarm_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USBWakeUp_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));

/* Vector table */
__attribute__((section(".isr_vector")))
void (* const g_pfnVectors[])(void) = {
    &_estack,                       /* Initial stack pointer */
    Reset_Handler,                  /* Reset handler */
    NMI_Handler,                    /* NMI handler */
    HardFault_Handler,              /* Hard fault handler */
    MemManage_Handler,              /* MPU fault handler */
    BusFault_Handler,               /* Bus fault handler */
    UsageFault_Handler,             /* Usage fault handler */
    0, 0, 0, 0,                     /* Reserved */
    SVC_Handler,                    /* SVCall handler */
    DebugMon_Handler,               /* Debug monitor handler */
    0,                              /* Reserved */
    PendSV_Handler,                 /* PendSV handler */
    SysTick_Handler,                /* SysTick handler */
    WWDG_IRQHandler,                /* Window Watchdog */
    PVD_IRQHandler,                 /* PVD through EXTI Line detect */
    TAMPER_IRQHandler,              /* Tamper */
    RTC_IRQHandler,                 /* RTC */
    FLASH_IRQHandler,               /* Flash */
    RCC_IRQHandler,                 /* RCC */
    EXTI0_IRQHandler,               /* EXTI Line 0 */
    EXTI1_IRQHandler,               /* EXTI Line 1 */
    EXTI2_IRQHandler,               /* EXTI Line 2 */
    EXTI3_IRQHandler,               /* EXTI Line 3 */
    EXTI4_IRQHandler,               /* EXTI Line 4 */
    DMA1_Channel1_IRQHandler,       /* DMA1 Channel 1 */
    DMA1_Channel2_IRQHandler,       /* DMA1 Channel 2 */
    DMA1_Channel3_IRQHandler,       /* DMA1 Channel 3 */
    DMA1_Channel4_IRQHandler,       /* DMA1 Channel 4 */
    DMA1_Channel5_IRQHandler,       /* DMA1 Channel 5 */
    DMA1_Channel6_IRQHandler,       /* DMA1 Channel 6 */
    DMA1_Channel7_IRQHandler,       /* DMA1 Channel 7 */
    ADC1_2_IRQHandler,              /* ADC1 and ADC2 */
    USB_HP_CAN1_TX_IRQHandler,      /* USB High Priority or CAN1 TX */
    USB_LP_CAN1_RX0_IRQHandler,     /* USB Low Priority or CAN1 RX0 */
    CAN1_RX1_IRQHandler,            /* CAN1 RX1 */
    CAN1_SCE_IRQHandler,            /* CAN1 SCE */
    EXTI9_5_IRQHandler,             /* EXTI Line[9:5]s */
    TIM1_BRK_IRQHandler,            /* TIM1 Break */
    TIM1_UP_IRQHandler,             /* TIM1 Update */
    TIM1_TRG_COM_IRQHandler,        /* TIM1 Trigger and Commutation */
    TIM1_CC_IRQHandler,             /* TIM1 Capture Compare */
    TIM2_IRQHandler,                /* TIM2 */
    TIM3_IRQHandler,                /* TIM3 */
    TIM4_IRQHandler,                /* TIM4 */
    I2C1_EV_IRQHandler,             /* I2C1 Event */
    I2C1_ER_IRQHandler,             /* I2C1 Error */
    I2C2_EV_IRQHandler,             /* I2C2 Event */
    I2C2_ER_IRQHandler,             /* I2C2 Error */
    SPI1_IRQHandler,                /* SPI1 */
    SPI2_IRQHandler,                /* SPI2 */
    USART1_IRQHandler,              /* USART1 */
    USART2_IRQHandler,              /* USART2 */
    USART3_IRQHandler,              /* USART3 */
    EXTI15_10_IRQHandler,           /* EXTI Line[15:10]s */
    RTC_Alarm_IRQHandler,           /* RTC Alarm through EXTI Line */
    USBWakeUp_IRQHandler,           /* USB Wakeup from suspend */
    0, 0, 0, 0, 0, 0, 0,            /* Reserved */
    (void (*)(void))0xF108F85F      /* Boot in RAM mode for STM32F10x Medium Density devices */
};

/**
  * @brief  This is the code that gets called when the processor first
  *         starts execution following a reset event. Only the absolutely
  *         necessary set is performed, after which the application
  *         supplied main() routine is called.
  * @param  None
  * @retval None
  */
void Reset_Handler(void) {
    uint32_t *pSrc, *pDest;

    /* Initialize the system */
    SystemInit();

    /* Copy the data segment initializers from flash to SRAM */
    pSrc = &_sidata;
    pDest = &_sdata;
    while (pDest < &_edata) {
        *pDest++ = *pSrc++;
    }

    /* Zero fill the .bss segment */
    pDest = &_sbss;
    while (pDest < &_ebss) {
        *pDest++ = 0;
    }

    /* Call static constructors */
    __libc_init_array();

    /* Call the application's entry point */
    main();
}

/**
  * @brief  This is the code that gets called when the processor receives an
  *         unexpected interrupt. This simply enters an infinite loop, preserving
  *         the system state for examination by a debugger.
  * @param  None
  * @retval None
  */
void Default_Handler(void) {
    while (1) {
        ; /* Halt - Wait for WDGT Reset (If valid) */
    }
}
