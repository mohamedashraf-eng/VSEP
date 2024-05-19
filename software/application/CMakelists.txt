cmake_minimum_required(VERSION 3.10)

# building appliction
message( STATUS "Building Application")

if(SOFTWARE_COMPONENT STREQUAL "bootloader_swc")
    add_subdirectory("${bootloader_swc}")
elseif(SOFTWARE_COMPONENT STREQUAL "target_app_swc")
    add_subdirectory("${target_app_swc}")
else()
    message(FATAL_ERROR "Unknown SOFTWARE_COMPONENT: ${SOFTWARE_COMPONENT}")
endif()