#!/bin/bash

rebuild=$1
ide=$2
num_cores=$(nproc)

GCC_PATH="/opt/compilers/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux/bin/"
CMAKE_TA_SWC_PATH_HEX="/workspace/tools/build/CMake/output/build/cf4a_gp_targetapp.hex"
CMAKE_BTL_SWC_PATH_BIN="/workspace/tools/build/CMake/output/build/cf4a_gp_bootloader.bin"
CMAKE_BTL_SWC_PATH_HEX="/workspace/tools/build/CMake/output/build/cf4a_gp_bootloader.hex"
CMAKE_TA_SWC_PATH_BIN="/workspace/tools/build/CMake/output/build/cf4a_gp_targetapp.bin"

IDE_BTL_SWC_PATH_ELF="/workspace/tools/build/IDE/BootloaderX/build/build/cf4a_gp_bootloader.elf"
IDE_BTL_SWC_PATH_HEX="/workspace/tools/build/IDE/BootloaderX/build/build/cf4a_gp_bootloader.hex"
IDE_BTL_SWC_PATH_BIN="/workspace/tools/build/IDE/BootloaderX/build/build/cf4a_gp_bootloader.bin"
IDE_TA_SWC_PATH_ELF="/workspace/tools/build/IDE/TargetAppX/build/build/cf4a_gp_targetapp.elf"
IDE_TA_SWC_PATH_HEX="/workspace/tools/build/IDE/TargetAppX/build/build/cf4a_gp_targetapp.hex"
IDE_TA_SWC_PATH_BIN="/workspace/tools/build/IDE/TargetAppX/build/build/cf4a_gp_targetapp.bin"

TA_SWC_RDR_PATH="/workspace/website/fota/firmwares"
IDE_OUTPUT_PATH="/workspace/tools/build/IDE/output"
FLASH_UTIL_RDR_PATH="/workspace/tools/utils/Flashers"

# Color codes for styling
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
BOLD="\033[1m"
RESET="\033[0m"

# Function to echo colored text
echo_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${RESET}"
}

# Function to check if a file exists
check_file_exists() {
    if [ ! -f "$1" ]; then
        echo_color $RED "${BOLD}Error: File '$1' not found.${RESET}"
        exit 1
    fi
}

# Pre conditions
echo "------------------------------------------------------------------------------------------------------"
echo_color $GREEN "${BOLD}Installing Dependencies${RESET}"
if ! pip install -r tools/utils/requirements.txt; then
    echo_color $RED "${BOLD}Error: Failed to install dependencies.${RESET}"
    exit 1
fi
echo "------------------------------------------------------------------------------------------------------"

# Build the project
echo_color $BLUE "${BOLD}Building Software${RESET}"

if [ "$ide" == "1" ]; then 
    if [ "$rebuild" == "1" ]; then
        echo_color $BLUE "${BOLD}Rebuilding is True${RESET}"
        make clean -C tools/build/IDE/BootloaderX/build GCC_PATH="$GCC_PATH" || {
            echo_color $RED "${BOLD}Error: Failed to clean BootloaderX build.${RESET}"
            exit 1
        }
        make clean -C tools/build/IDE/TargetAppX/build GCC_PATH="$GCC_PATH" || {
            echo_color $RED "${BOLD}Error: Failed to clean TargetAppX build.${RESET}"
            exit 1
        }
    fi
    echo_color $BLUE "${BOLD}Building from IDE${RESET}"
    echo_color $BLUE "Building Bootloader${RESET}"
    if ! make all -j$num_cores -C tools/build/IDE/BootloaderX/build GCC_PATH="$GCC_PATH" > /dev/null 2>&1; then
        echo_color $RED "${BOLD}Error: Failed to build bootloader.${RESET}"
        exit 1
    else
        echo_color $BLUE "Bootloader built successfully.${RESET}"
    fi
    echo_color $BLUE "Building TargetApp${RESET}"
    if ! make all -j$num_cores -C tools/build/IDE/TargetAppX/build GCC_PATH="$GCC_PATH" > /dev/null 2>&1; then
        echo_color $RED "${BOLD}Error: Failed to build application.${RESET}"
        exit 1
    else
        echo_color $BLUE "Application built successfully.${RESET}"
    fi
    # Redirect output files to the 'output' folder
    if ! mkdir -p "$IDE_OUTPUT_PATH"; then
        echo_color $RED "${BOLD}Error: Failed to create output directory.${RESET}"
        exit 1
    else
        if ! cp "$IDE_BTL_SWC_PATH_HEX" "$IDE_OUTPUT_PATH" || \
           ! cp "$IDE_BTL_SWC_PATH_BIN" "$IDE_OUTPUT_PATH" || \
           ! cp "$IDE_BTL_SWC_PATH_ELF" "$IDE_OUTPUT_PATH" || \
           ! cp "$IDE_TA_SWC_PATH_HEX" "$IDE_OUTPUT_PATH" || \
           ! cp "$IDE_TA_SWC_PATH_BIN" "$IDE_OUTPUT_PATH" || \
           ! cp "$IDE_TA_SWC_PATH_ELF" "$IDE_OUTPUT_PATH"; then
            echo_color $RED "${BOLD}Error: Failed to copy output files to the 'output' folder.${RESET}"
            exit 1
        fi
    fi
else
    echo_color $BLUE "${BOLD}Building from CMake${RESET}"
    if [ "$rebuild" == "1" ]; then
        echo_color $BLUE "${BOLD}Rebuilding is True${RESET}"
        if ! make build_bootloader rebuild=1 || ! make build_target_app rebuild=1; then
            echo_color $RED "${BOLD}Error: Build failed.${RESET}"
            exit 1
        fi
    else
        if ! make build_bootloader || ! make build_target_app; then
            echo_color $RED "${BOLD}Error: Build failed.${RESET}"
            exit 1
        fi
    fi
fi

echo "------------------------------------------------------------------------------------------------------"
# Run hash calculator on output [Bootloader SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_bootloader hash [SHA256] and size [BYTES].${RESET}"
if [ "$ide" == "1" ]; then 
    check_file_exists "${IDE_BTL_SWC_PATH_HEX}"
    if ! python3 tools/utils/firmware_hash_calculator.py -fp "${IDE_BTL_SWC_PATH_HEX}"; then
        echo_color $RED "${BOLD}Error: Failed to calculate hash and size for bootloader.${RESET}"
        exit 1
    fi
else
    check_file_exists "${CMAKE_BTL_SWC_PATH_HEX}"
    if ! python3 tools/utils/firmware_hash_calculator.py -fp "${CMAKE_BTL_SWC_PATH_HEX}"; then
        echo_color $RED "${BOLD}Error: Failed to calculate hash and size for bootloader.${RESET}"
        exit 1
    fi
fi
echo "------------------------------------------------------------------------------------------------------"
# Run hash calculator on output [Target App SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_targetapp hash [SHA256] and size [BYTES].${RESET}"
if [ "$ide" == "1" ]; then 
    check_file_exists "${IDE_TA_SWC_PATH_HEX}"
    if ! python3 tools/utils/firmware_hash_calculator.py -fp "${IDE_TA_SWC_PATH_HEX}" | tee "${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt"; then
        echo_color $RED "${BOLD}Error: Failed to calculate hash and size for target app.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.HASH] > ${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt${RESET}"
    fi
else
    check_file_exists "${CMAKE_TA_SWC_PATH_HEX}"
    if ! python3 tools/utils/firmware_hash_calculator.py -fp "${CMAKE_TA_SWC_PATH_HEX}" | tee "${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt"; then
        echo_color $RED "${BOLD}Error: Failed to calculate hash and size for target app.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.HASH] > ${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt${RESET}"
    fi
fi
echo "------------------------------------------------------------------------------------------------------"
# Redirect the output of Target Application
if [ "$ide" == "1" ]; then 
    check_file_exists "${IDE_TA_SWC_PATH_HEX}"
    check_file_exists "${IDE_BTL_SWC_PATH_BIN}"
    if ! cp "${IDE_TA_SWC_PATH_HEX}" "${TA_SWC_RDR_PATH}/UpdatedFirmware.hex"; then
        echo_color $RED "${BOLD}Error: Failed to copy application hex file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.HEX] > ${TA_SWC_RDR_PATH}/UpdatedFirmware.hex${RESET}"
    fi
    if ! cp "${IDE_TA_SWC_PATH_BIN}" "${FLASH_UTIL_RDR_PATH}/TargetApplication.bin"; then
        echo_color $RED "${BOLD}Error: Failed to copy application bin file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.BIN] > ${FLASH_UTIL_RDR_PATH}/TargetApplication.bin${RESET}"
    fi
    if ! cp "${IDE_BTL_SWC_PATH_BIN}" "${FLASH_UTIL_RDR_PATH}/Bootloader.bin"; then
        echo_color $RED "${BOLD}Error: Failed to copy bootloader bin file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Bootloader [.BIN] > ${FLASH_UTIL_RDR_PATH}/Bootloader.bin${RESET}"
    fi
else
    check_file_exists "${CMAKE_TA_SWC_PATH_HEX}"
    check_file_exists "${CMAKE_BTL_SWC_PATH_BIN}"
    if ! cp "${CMAKE_TA_SWC_PATH_HEX}" "${TA_SWC_RDR_PATH}/UpdatedFirmware.hex"; then
        echo_color $RED "${BOLD}Error: Failed to copy application hex file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.HEX] > ${TA_SWC_RDR_PATH}/UpdatedFirmware.hex${RESET}"
    fi
    if ! cp "${CMAKE_TA_SWC_PATH_BIN}" "${FLASH_UTIL_RDR_PATH}/TargetApplication.bin"; then
        echo_color $RED "${BOLD}Error: Failed to copy application bin file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Target Application [.BIN] > ${FLASH_UTIL_RDR_PATH}/TargetApplication.BIN${RESET}"
    fi
    if ! cp "${CMAKE_BTL_SWC_PATH_BIN}" "${FLASH_UTIL_RDR_PATH}/Bootloader.bin"; then
        echo_color $RED "${BOLD}Error: Failed to copy bootloader bin file.${RESET}"
        exit 1
    else
        echo_color $YELLOW "${BOLD}Redirected the Bootloader [.BIN] > ${FLASH_UTIL_RDR_PATH}/Bootloader.bin${RESET}"
    fi
fi
echo "------------------------------------------------------------------------------------------------------"

