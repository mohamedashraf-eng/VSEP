# Yocto Image for Raspberry Pi 3B+

This guide provides step-by-step instructions to build a Yocto image for the Raspberry Pi 3B+.

## Usage  
You can run the script `build_yocto_rpi.sh` and it will do all below steps required.

## Prerequisites

Ensure you have the required dependencies installed on your system. Use the following command to install them:

```bash
apt install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm
```

## Cloning the Repositories  

1. Create and Navigate to the Working Directory:  

```bash  
cd yocto/poky_dunfell
```  

2. Clone the poky Repository:  

```bash  
git clone -b dunfell git://git.yoctoproject.org/poky.git .
```  

3. Clone the meta-raspberrypi Layer:  

```bash  
git clone -b dunfell git://git.yoctoproject.org/meta-raspberrypi
```  

## Setting Up the Build Environment

1. Source the Environment Setup Script:  

```bash  
source oe-init-build-env && cd build/
```  

2. Add the meta-raspberrypi Layer to bblayers.conf: `Added by default in `build/conf` (No need to do this step)`

3. Configure the Build for Raspberry Pi 3B+: `Added by default in `build/conf` (No need to do this step)`

## Building the Image  

```bash
bitbake core-image-minimal-dev
```

## Flashing the Image to an SD Card  
After the build is complete, the output images will be located in the tmp/deploy/images/raspberrypi3/ directory.

1. Identify the Image File:


2. Flash the Image to an SD Card:

```bash
dd if=tmp/deploy/images/raspberrypi3/core-image-minimal-dev-raspberrypi3.sdimg of=/dev/sdX bs=4M && sync
```

## Additional Documentation and Resources

- Yocto Project Documentation: [Yocto Project Reference Manual](https://docs.yoctoproject.org/ref-manual/index.html)
- meta-raspberrypi Layer: [meta-raspberrypi GitHub Repository](https://github.com/agherzan/meta-raspberrypi)
- BitBake User Manual: [BitBake User Manual](https://docs.yoctoproject.org/bitbake/)

By following these steps, you should be able to successfully build and deploy a Yocto image for the Raspberry Pi 3B+. If you encounter any issues, refer to the documentation or seek help from the Yocto community.

css  
You can copy the above guide as it contains all necessary steps and instructions to build and deploy a Yocto image for the Raspberry Pi 3B+.
