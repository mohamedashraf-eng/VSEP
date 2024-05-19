# CMake Version Check
cmake_minimum_required(VERSION 3.14)

# Project
project(hal_drivers 
        LANGUAGES C CXX
        VERSION "1.0.0"
        DESCRIPTION "hal_drivers")

##############################################################################        
# Include Common Compilation Settings                                       #
##############################################################################

include(tools/cmake/hal_drivers_compile.cmake)

##############################################################################
# Extract Module Path in build/CMake/Test/                                   #
##############################################################################

##############################################################################
# Build Configuration                                                        #
##############################################################################

# Compilation Mode: Only build the library
if(MODE STREQUAL "COMPILING")
  add_library(hal_drivers ${hal_drivers_sources_list})
  target_compile_options(hal_drivers PRIVATE ${hal_drivers_compile_options})
  target_include_directories(hal_drivers PRIVATE ${hal_drivers_includes})
  target_compile_definitions(hal_drivers PRIVATE ${hal_drivers_defines})
elseif (MODE STREQUAL "TESTING")
  include(tools/cmake/hal_drivers_tests.cmake)
  add_library(hal_drivers ${hal_drivers_ut_sources_list})
  target_compile_options(hal_drivers PRIVATE ${hal_drivers_tests_compile_options})
  target_include_directories(hal_drivers PRIVATE ${hal_drivers_tests_includes})
  target_compile_definitions(hal_drivers PRIVATE ${hal_drivers_tests_defines})
endif()