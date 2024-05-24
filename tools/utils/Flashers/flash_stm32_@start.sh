#!/usr/bin/env bash


FlashBinaryFileName=$1

sudo st-flash write $FlashBinaryFileName 0x08000000

sudo st-flash reset
