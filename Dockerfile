FROM ubuntu:22.04

# Avoid stuck at console asking for input
ARG DEBIAN_FRONTEND=noninteractive

# Install compiler and other tools
RUN apt-get update && \
    apt-get install -y \
    make \
    cmake \
    lsb-release \
    git \
    file \
    aptitude \
    gcc-multilib \
    python3 \
    python3-pip \
    wget \
    xz-utils \
    ruby \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install junit2html

# Download ARM GCC compiler
RUN wget -O gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2?rev=78196d3461ba4c9089a67b5f33edf82a&hash=D484B37FF37D6FC3597EBE2877FB666A41D5253B"

# Extract ARM GCC compiler into a folder inside /opt/compilers
RUN mkdir -p /opt/compilers/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux && \
    tar xf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /opt/compilers/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux --strip-components=1 && \
    rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

# Install gcovr tool
RUN pip install gcovr==7.2

# Set the default command
CMD ["/bin/bash"]
