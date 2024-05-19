#!/bin/bash

BTL_SWC_PATH_OUT="/workspace/tools/build/CMake/output/build/cf4a_gp_bootloader.out"
TA_SWC_PATH_OUT="/workspace/tools/build/CMake/output/build/cf4a_gp_targetapp.out"

# Pre conditions
echo "Install Depends [utils]"
pip install -r tools/utils/requirements.txt

# Build the project
echo "Building Software"
make build_bootloader && make build_target_app

# # Run hash calculator on output [Bootloader SWC]
# echo "Calculating cf4a_gp_bootloader hash [SHA256] and size."
# python3 tools/utils/firmware_hash_calculator.py -fp "${BTL_SWC_PATH_OUT}"

# # Run hash calculator on output [Target App SWC]
# echo "Calculating cf4a_gp_targetapp hash [SHA256] and size."
# python3 tools/utils/firmware_hash_calculator.py -fp "${TA_SWC_PATH_OUT}"
