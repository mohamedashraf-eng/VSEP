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

extract_module_path(hal_drivers MOCK_FILE_PATH)

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

if(MODE STREQUAL "TESTING")
  # Execute CMock script
  execute_process(
    COMMAND ruby ${CMOCK_SCRIPT} -o${CMOCK_CONFIG_FILE} ${hal_drivers_mock_header_files}
    OUTPUT_VARIABLE CMOCK_OUTPUT
    WORKING_DIRECTORY ${MOCK_FILE_PATH}  #  /workspace/tools/build/CMake/Test/software/bsw/mcal/hal_drivers
  )
  message("CMock output: ${CMOCK_OUTPUT}")

  # Testing Mode: Build the library and test executable
  add_executable(hal_drivers_test ${hal_drivers_tests_sources_list} ${unity_common_sources})
  target_compile_definitions(hal_drivers_test PRIVATE ${hal_drivers_tests_defines})
  target_compile_options(hal_drivers_test PRIVATE ${hal_drivers_tests_compile_options})
  target_include_directories(hal_drivers_test PRIVATE ${hal_drivers_tests_includes} ${unity_common_includes})
  target_link_libraries(hal_drivers_test PRIVATE hal_drivers)
endif()