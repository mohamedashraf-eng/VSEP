/**
******************************************************************************
* @file           : simple_vehicle_ops.h
* @brief          : simple_vehicle_ops public interface file
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
#ifndef __SIMPLE_VEHICLE_OPS_H__
#define __SIMPLE_VEHICLE_OPS_H__

#ifdef __cplusplus
extern "c" {
#endif /* __cplusplus */

#include "Std_Types.h"
/* ****************************************************************** */

//#define DBG
//#define DIRECT_BOOTLOADER_JUMP

/* ****************************************************************** */

/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
//!                     Application Configurations
/* ****************************************************************** */
//
/** //! MOTOR_SPEED: (45 - 100) */
//
#define MOTORS_SPEED								(  (50) )
//
/** //! FRONT_LEDS_INTENSITY: (10 - 100) */
//
#define FRONT_LEDS_INTENSITY						(  (80) )
/** //! USS_THRESHOLD_DISTANCE_CM: (10 - 150) */
//
#define USS_THRESHOLD_DISTANCE_CM					( (15) )
//
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */
/* ****************************************************************** */

void vehicle_init(void);
void app_main(void);
/* ****************************************************************** */

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* __SIMPLE_VEHICLE_OPS_H__ */
