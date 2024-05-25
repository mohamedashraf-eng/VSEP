/**
******************************************************************************
* @file           : fee_intf.h
* @brief          : Flash EEPROM Emulator Interface
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
* Autosar Version      : 4.4.0
* SW Version           : 1.0.0
* =============================================================================
*/
#ifndef __FEE_INTF_H__
#define __FEE_INTF_H__

#include "Std_Types.h"
#include "main.h"

/**
* ===============================================================================================
*   > Public Macros
* ===============================================================================================
*/

#define FEE_START_ADDRESS       (0x08007000)
#define FEE_PAGE_SIZE           (0x400U)
#define FEE_BUFFER_LEN          (FEE_PAGE_SIZE/2u)

/**
* ===============================================================================================
*   > Public Structs
* ===============================================================================================
*/

/**
* ===============================================================================================
*   > Public Enums
* ===============================================================================================
*/

/**
* ===============================================================================================
*   > Public Datatypes
* ===============================================================================================
*/


/**
* ===============================================================================================
*   > Public Functions Declaration
* ===============================================================================================
*/

#ifdef __cplusplus 
extern "c" {
#endif /* __cplusplus */

HAL_StatusTypeDef FEE_Write(uint32 Arg_u32Address, uint16* pArg_u16Data, uint32 Arg_u32DSize);
__NORETURN FEE_Read(uint32 Arg_u32Address, uint16* pArg_u16Data, uint32 Arg_u32DSize);
__NORETURN FEE_WriteData(uint32 Arg_u32Address, void* pArg_u16Data, uint32 Arg_u32DSize);
__NORETURN FEE_ReadData(uint32 Arg_u32Address, void* pArg_u16Data, uint32 Arg_u32DSize);

#ifdef __cplusplus 
}
#endif /* __cplusplus */
#endif /* __FEE_INTF_H__ */
