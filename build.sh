#!/bin/bash

BTL_SWC_PATH_BIN="/workspace/tools/build/CMake/output/build/cf4a_gp_bootloader.bin"
TA_SWC_PATH_BIN="/workspace/tools/build/CMake/output/build/cf4a_gp_targetapp.bin"
BTL_SWC_PATH_HEX="/workspace/tools/build/CMake/output/build/cf4a_gp_bootloader.hex"
TA_SWC_PATH_HEX="/workspace/tools/build/CMake/output/build/cf4a_gp_targetapp.hex"
TA_SWC_RDR_PATH="/workspace/website/fota/firmwares"

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
    
    fi
}

# Pre conditions
echo ------------------------------------------------------------------------------------------------------
echo_color $GREEN "${BOLD}Install Depends [utils]${RESET}"
if ! pip install -r tools/utils/requirements.txt; then
    echo_color $RED "${BOLD}Error: Failed to install dependencies.${RESET}"

fi
echo ------------------------------------------------------------------------------------------------------

# Build the project
echo_color $BLUE "${BOLD}Building Software${RESET}"
if ! make build_bootloader || ! make build_target_app; then
    echo_color $RED "${BOLD}Error: Build failed.${RESET}"

fi
echo ------------------------------------------------------------------------------------------------------

# Run hash calculator on output [Bootloader SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_bootloader hash [SHA256] and size [BYTES].${RESET}"
check_file_exists "${BTL_SWC_PATH_BIN}"
if ! python3 tools/utils/firmware_hash_calculator.py -fp "${BTL_SWC_PATH_BIN}"; then
    echo_color $RED "${BOLD}Error: Failed to calculate hash and size for bootloader.${RESET}"

fi
echo ------------------------------------------------------------------------------------------------------

# Run hash calculator on output [Target App SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_targetapp hash [SHA256] and size [BYTES].${RESET}"
check_file_exists "${TA_SWC_PATH_BIN}"
if ! python3 tools/utils/firmware_hash_calculator.py -fp "${TA_SWC_PATH_BIN}" | tee "${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt"; then
    echo_color $RED "${BOLD}Error: Failed to calculate hash and size for target app.${RESET}"

fi
echo ------------------------------------------------------------------------------------------------------

# Redirect the output of Target Application
echo_color $YELLOW "${BOLD}Redirecting the Target Application [.HEX] > ${TA_SWC_RDR_PATH}${RESET}"
check_file_exists "${TA_SWC_PATH_HEX}"
if ! cp "${TA_SWC_PATH_HEX}" "${TA_SWC_RDR_PATH}/UpdatedFirmware.hex"; then
    echo_color $RED "${BOLD}Error: Failed to copy hex file.${RESET}"

fi
echo_color $YELLOW "${BOLD}Redirected the Target Application [.HEX] > ${TA_SWC_RDR_PATH}${RESET}"

echo_color $YELLOW "${BOLD}Redirecting the Target Application [.HASH] > ${TA_SWC_RDR_PATH}${RESET}"
echo ------------------------------------------------------------------------------------------------------
