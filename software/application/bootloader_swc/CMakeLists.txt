# CMake Version Check
cmake_minimum_required(VERSION 3.14)

# Project
project(bootloader_swc 
        LANGUAGES C CXX
        VERSION "1.0.0"
        DESCRIPTION "bootloader_swc")

set(SOFTWARE_COMPONENT "bootloader_swc")
##############################################################################
# Include Common Compilation Settings                                       #
##############################################################################

include(tools/cmake/bootloader_swc_compile.cmake)

##############################################################################
# Build Configuration                                                        #
##############################################################################

# Compilation Mode: Only build the library
if(MODE STREQUAL "COMPILING")
  add_executable(bootloader_swc ${bootloader_swc_sources_list})
  target_compile_options(bootloader_swc PRIVATE ${bootloader_swc_compile_options})
  target_include_directories(bootloader_swc PRIVATE ${bootloader_swc_includes})
  target_compile_definitions(bootloader_swc PRIVATE ${bootloader_swc_defines})
  target_link_libraries(bootloader_swc PRIVATE ${bootloader_swc_libs})

  # Installation
  install( PROGRAMS $<TARGET_FILE:bootloader_swc>  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ DESTINATION ${CMAKE_BINARY_DIR}/../output/build RENAME cf4a_gp_bootloader.out)
  install( FILES    $<TARGET_FILE:bootloader_swc>.map DESTINATION ${CMAKE_BINARY_DIR}/../output/build RENAME cf4a_gp_bootloader.map)

  # Define the marker file path
  set(MARKER_FILE "${CMAKE_BINARY_DIR}/marker.txt")

  # Check if the marker file exists
  if(NOT EXISTS ${MARKER_FILE})
      # This is the first build, so create the marker file
      file(WRITE ${MARKER_FILE} "")
      set(FIRST_BUILD TRUE)
      message("First build configuration")
  else()
      set(FIRST_BUILD FALSE)
  endif()

  # Output directory for generated files
  set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/../output/build")

  # Output paths for .elf, .hex, and .bin files
  set(ELF_FILE "${OUTPUT_DIR}/cf4a_gp_bootloader.elf")
  set(HEX_FILE "${OUTPUT_DIR}/cf4a_gp_bootloader.hex")
  set(BIN_FILE "${OUTPUT_DIR}/cf4a_gp_bootloader.bin")

  # Generate .elf file
  add_custom_command(TARGET bootloader_swc POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_DIR}
      COMMAND ${CMAKE_COMMAND} -E touch ${ELF_FILE}
      COMMAND ${CMAKE_OBJCOPY} -O elf32-littlearm $<TARGET_FILE:bootloader_swc> ${ELF_FILE}
      COMMENT "Generating .elf file"
  )

  # Generate .hex and .bin files
  add_custom_command(TARGET bootloader_swc POST_BUILD
      COMMAND ${CMAKE_OBJCOPY} -O ihex ${ELF_FILE} ${HEX_FILE}
      COMMAND ${CMAKE_OBJCOPY} -O binary ${ELF_FILE} ${BIN_FILE}
      COMMENT "Generating .hex and .bin files"
  )

  # Install .elf, .hex, and .bin files if it's not the first build
  if(NOT FIRST_BUILD)
      install(FILES ${ELF_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_bootloader.elf)
      install(FILES ${HEX_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_bootloader.hex)
      install(FILES ${BIN_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_bootloader.bin)
  endif()

elseif (MODE STREQUAL "TESTING")
    include(tools/cmake/bootloader_swc_tests.cmake)
    add_library(bootloader_swc ${bootloader_swc_ut_sources_list})
    target_compile_options(bootloader_swc PRIVATE ${bootloader_swc_tests_compile_options})
    target_include_directories(bootloader_swc PRIVATE ${bootloader_swc_tests_includes})
    target_compile_definitions(bootloader_swc PRIVATE ${bootloader_swc_tests_defines})
endif()

if(MODE STREQUAL "TESTING")
  # Execute CMock script
  execute_process(
    COMMAND ruby ${CMOCK_SCRIPT} -o${CMOCK_CONFIG_FILE} ${bootloader_swc_mock_header_files}
    OUTPUT_VARIABLE CMOCK_OUTPUT
    WORKING_DIRECTORY ${MOCK_FILE_PATH}  #  /workspace/tools/build/CMake/Test/software/application/bootloader_swc
  )
  message("CMock output: ${CMOCK_OUTPUT}")

  # Testing Mode: Build the library and test executable
  add_executable(bootloader_swc_test ${bootloader_swc_tests_sources_list} ${unity_common_sources})
  target_compile_definitions(bootloader_swc_test PRIVATE ${bootloader_swc_tests_defines})
  target_compile_options(bootloader_swc_test PRIVATE ${bootloader_swc_tests_compile_options})
  target_include_directories(bootloader_swc_test PRIVATE ${bootloader_swc_tests_includes} ${unity_common_includes})
  target_link_libraries(bootloader_swc_test PRIVATE bootloader_swc)
endif()
