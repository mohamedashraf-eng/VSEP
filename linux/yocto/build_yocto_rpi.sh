#!/bin/bash

# Script to build Yocto image for Raspberry Pi 3B+ 
# Brief: VSEP Deplyed Yocto Image
# Author: [Mohamed Wx]
# Date: [23 May 24]
# License: GPL-3.0 

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper function to print messages
function print_message {
    echo -e "${GREEN}$1${NC}"
}

function print_warning {
    echo -e "${YELLOW}$1${NC}"
}

function print_error {
    echo -e "${RED}$1${NC}"
}

# Step 1: Install dependencies
print_message "Step 1: Installing dependencies..."
apt update && apt install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm
if [ $? -ne 0 ]; then
    print_error "Failed to install dependencies. Exiting."
    exit 1
fi

# Step 2: Create and navigate to the working directory
WORKDIR=/poky_dunfell
print_message "Step 2: Creating and navigating to the working directory: $WORKDIR"
mkdir -p $WORKDIR
cd $WORKDIR
if [ $? -ne 0 ]; then
    print_error "Failed to create or navigate to $WORKDIR. Exiting."
    exit 1
fi

# Step 3: Clone the repositories
print_message "Step 3: Cloning the poky repository..."
git clone -b dunfell git://git.yoctoproject.org/poky.git .
if [ $? -ne 0 ]; then
    print_error "Failed to clone the poky repository. Exiting."
    exit 1
fi

print_message "Cloning the meta-raspberrypi repository..."
git clone -b dunfell git://git.yoctoproject.org/meta-raspberrypi
if [ $? -ne 0 ]; then
    print_error "Failed to clone the meta-raspberrypi repository. Exiting."
    exit 1
fi

# Step 4: Source the environment setup script
print_message "Step 4: Sourcing the environment setup script..."
source oe-init-build-env
if [ $? -ne 0 ]; then
    print_error "Failed to source oe-init-build-env. Exiting."
    exit 1
fi

# Step 5: Add the meta-raspberrypi layer to bblayers.conf
print_message "Step 5: Adding meta-raspberrypi layer to bblayers.conf..."
# BBLAYERS_CONF=conf/bblayers.conf
# if grep -q "meta-raspberrypi" $BBLAYERS_CONF; then
#     print_warning "meta-raspberrypi layer already present in bblayers.conf."
# else
#     echo "  ${TOPDIR}/../meta-raspberrypi \\" >> $BBLAYERS_CONF
#     if [ $? -ne 0 ]; then
#         print_error "Failed to add meta-raspberrypi layer to bblayers.conf. Exiting."
#         exit 1
#     fi
# fi

# Step 6: Configure the build for Raspberry Pi 3B+
print_message "Step 6: Configuring the build for Raspberry Pi 3B+..."
# LOCAL_CONF=conf/local.conf
# if grep -q "^MACHINE ?= \"raspberrypi3\"" $LOCAL_CONF; then
#     print_warning "MACHINE is already set to raspberrypi3 in local.conf."
# else
#     echo 'MACHINE ?= "raspberrypi3"' >> $LOCAL_CONF
#     if [ $? -ne 0 ]; then
#         print_error "Failed to set MACHINE in local.conf. Exiting."
#         exit 1
#     fi
# fi

# Optional: Add other configurations
print_message "Adding optional configurations to local.conf..."
# echo 'IMAGE_INSTALL_append = " linux-firmware-rpidistro-bcm43430"' >> $LOCAL_CONF
# echo 'GPU_MEM = "16"' >> $LOCAL_CONF

# Step 7: Build the image
print_message "Step 7: Building the image..."
bitbake core-image-minimal-dev
if [ $? -ne 0 ]; then
    print_error "Failed to build the image. Exiting."
    exit 1
fi

# Step 8: Flash the image to an SD card
print_message "Step 8: Flashing the image to an SD card..."
OUTPUT_IMAGE="tmp/deploy/images/raspberrypi3/core-image-minimal-dev-raspberrypi3.sdimg"
if [ ! -f "$OUTPUT_IMAGE" ]; then
    print_error "Image file not found: $OUTPUT_IMAGE. Exiting."
    exit 1
fi

print_message "Please insert your SD card and specify the device path (e.g., /dev/sdX):"
read SD_DEVICE
if [ -z "$SD_DEVICE" ]; then
    print_error "No device path specified. Exiting."
    exit 1
fi

print_message "Flashing the image to $SD_DEVICE..."
dd if=$OUTPUT_IMAGE of=$SD_DEVICE bs=4M && sync
if [ $? -ne 0 ]; then
    print_error "Failed to flash the image to $SD_DEVICE. Exiting."
    exit 1
fi

print_message "Yocto image for Raspberry Pi 3B+ built and flashed successfully!"
