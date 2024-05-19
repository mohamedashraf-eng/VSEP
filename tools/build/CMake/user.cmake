message(STATUS "SW_DIR = ${SW_DIR}")
message(STATUS "BUILD_TESTS_DIR = ${BUILD_TESTS_DIR}")

set( CMAKE_INSTALL_PREFIX "./" CACHE PATH "Default install path")

##############################################################################
# Common Directories                                                         #
##############################################################################
set( common_platform_includes "${SW_DIR}/common/platform/hal" CACHE PATH "Default")
set( common_asset_includes "${SW_DIR}/common/asset" CACHE PATH "Default")

set( application_dir "${SW_DIR}/application" CACHE PATH "Default")
set( bsw_dir "${SW_DIR}/bsw" CACHE PATH "Default")
set( mcal_dir "${SW_DIR}/bsw/mcal" CACHE PATH "Default")

##############################################################################
# MCAL Software Components                                                   #
##############################################################################
set( hal_drivers "${SW_DIR}/bsw/mcal/hal" CACHE PATH "Default")

##############################################################################
# App Software Components                                                    #
############################################################################## 
set( bootloader_swc  "${SW_DIR}/application/bootloader_swc" CACHE PATH "Default")
# set( bootloader_startup_file "${SW_DIR}/application/bootloader_swc/startup_stm32f103c8tx.s" CACHE PATH "Default")

set( target_app_swc  "${SW_DIR}/application/target_app_swc" CACHE PATH "Default")
# set( target_app_startup_file "${SW_DIR}/application/target_app_swc/startup_stm32f103c8tx.s" CACHE PATH "Default")
##############################################################################
# Frameworks                                                                 #
############################################################################## 

##############################################################################
# Dependencies                                                               #
##############################################################################

##############################################################################
# Functions                                                                 #
##############################################################################