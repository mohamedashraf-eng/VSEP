/**
******************************************************************************
* @file           : fee_prg.c
* @brief          : fee implementation file
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
/** @defgroup fee libs */
#include "fee_intf.h"
/** @defgroup ST libs */
/** @defgroup STD Libs */
#include <string.h>

HAL_StatusTypeDef FEE_Write(uint32 Arg_u32Address, uint16 *pArg_u16Data, uint32 Arg_u32DSize)
{
    HAL_StatusTypeDef status = HAL_OK;
    uint32 pageArg_u32Address = Arg_u32Address & ~(FLASH_PAGE_SIZE - 1); // Get the start Arg_u32Address of the page
    uint16 buffer[FEE_BUFFER_LEN]; // Create a buffer to hold the entire page
    HAL_FLASH_Unlock();
    // Read the entire page into the buffer
    for (uint32 i = 0; i < FEE_BUFFER_LEN; i++) {
        buffer[i] = *(__IO uint16*)(pageArg_u32Address + i * 2);
    }
    // Modify the values at the desired Arg_u32Address
    uint32 offset = Arg_u32Address - pageArg_u32Address;
    for (uint32 i = 0; i < Arg_u32DSize; i++) {
        buffer[offset / 2 + i] = pArg_u16Data[i];
    }
    // Erase the page
    FLASH_EraseInitTypeDef eraseInitStruct;
    eraseInitStruct.TypeErase = FLASH_TYPEERASE_PAGES;
    eraseInitStruct.PageAddress = pageArg_u32Address;
    eraseInitStruct.NbPages = 1;
    uint32 pageError;
    status = HAL_FLASHEx_Erase(&eraseInitStruct, &pageError);
    if (status != HAL_OK) {
        HAL_FLASH_Lock();
        return status;
    }
    // Write the modified buffer back to the page
    for (uint32 i = 0; i < FEE_BUFFER_LEN; i++) {
        status = HAL_FLASH_Program(FLASH_TYPEPROGRAM_HALFWORD, pageArg_u32Address + i * 2, buffer[i]);
        if (status != HAL_OK) {
            break;
        }
    }
    HAL_FLASH_Lock();
    return status;
}

void FEE_Read(uint32 Arg_u32Address, uint16 *pArg_u16Data, uint32 Arg_u32DSize)
{
    for (uint32 i = 0; i < Arg_u32DSize; i++) {
        pArg_u16Data[i] = *(__IO uint16*)Arg_u32Address;
        Arg_u32Address += 2;
    }
}

// Generic APIs For Any pArg_u16Data Type
void FEE_WriteData(uint32 Arg_u32Address, void *pArg_u16Data, uint32 Arg_u32DSize)
{
    uint16 bytes[Arg_u32DSize / 2];
    memcpy(bytes, pArg_u16Data, Arg_u32DSize);
    FEE_Write(Arg_u32Address, bytes, Arg_u32DSize);
}

void FEE_ReadData(uint32 Arg_u32Address, void *pArg_u16Data, uint32 Arg_u32DSize)
{
    uint16 bytes[Arg_u32DSize / 2];
    FEE_Read(Arg_u32Address, bytes, Arg_u32DSize);
    memcpy(pArg_u16Data, bytes, Arg_u32DSize);
}