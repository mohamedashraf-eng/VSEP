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
echo ------------------------------------------------------------------------------------------------------
# Pre conditions
echo_color $GREEN "${BOLD}Install Depends [utils]${RESET}"
pip install -r tools/utils/requirements.txt
echo ------------------------------------------------------------------------------------------------------
# Build the project
echo_color $BLUE "${BOLD}Building Software${RESET}"
make build_bootloader && make build_target_app
echo ------------------------------------------------------------------------------------------------------
# Run hash calculator on output [Bootloader SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_bootloader hash [SHA256] and size [BYTES].${RESET}"
python3 tools/utils/firmware_hash_calculator.py -fp "${BTL_SWC_PATH_BIN}"
echo ------------------------------------------------------------------------------------------------------
# Run hash calculator on output [Target App SWC]
echo_color $YELLOW "${BOLD}Calculating cf4a_gp_targetapp hash [SHA256] and size [BYTES].${RESET}"
python3 tools/utils/firmware_hash_calculator.py -fp "${TA_SWC_PATH_BIN}" | tee "${TA_SWC_RDR_PATH}/UpdatedFirmwareHash.txt"
echo ------------------------------------------------------------------------------------------------------
# Redirect the  output of Target Application
echo_color $YELLOW "Redirected the Target Application [.HEX] > ${TA_SWC_RDR_PATH}${RESET}"
cp "${TA_SWC_PATH_HEX}" "${TA_SWC_RDR_PATH}/UpdatedFirmware.hex"
echo_color $YELLOW "Redirected the Target Application [.HASH] > ${TA_SWC_RDR_PATH}${RESET}"
echo ------------------------------------------------------------------------------------------------------