# CMake Version Check
cmake_minimum_required(VERSION 3.14)

# Project
project(target_app_swc 
        LANGUAGES C CXX
        VERSION "1.0.0"
        DESCRIPTION "target_app_swc")

set(SOFTWARE_COMPONENT "target_app_swc")
##############################################################################
# Include Common Compilation Settings                                       #
##############################################################################

include(tools/cmake/target_app_swc_compile.cmake)

##############################################################################
# Build Configuration                                                        #
##############################################################################

# Compilation Mode: Only build the library
if(MODE STREQUAL "COMPILING")
  add_executable(target_app_swc ${target_app_swc_sources_list})
  target_compile_options(target_app_swc PRIVATE ${target_app_swc_compile_options})
  target_include_directories(target_app_swc PRIVATE ${target_app_swc_includes})
  target_compile_definitions(target_app_swc PRIVATE ${target_app_swc_defines})
  target_link_libraries(target_app_swc PRIVATE ${target_app_swc_libs})

  # Installation
  install( PROGRAMS $<TARGET_FILE:target_app_swc>  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ DESTINATION ${CMAKE_BINARY_DIR}/../output/build RENAME cf4a_gp_targetapp.out)
  install( FILES    $<TARGET_FILE:target_app_swc>.map DESTINATION ${CMAKE_BINARY_DIR}/../output/build RENAME cf4a_gp_targetapp.map  )

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
  set(ELF_FILE "${OUTPUT_DIR}/cf4a_gp_targetapp.elf")
  set(HEX_FILE "${OUTPUT_DIR}/cf4a_gp_targetapp.hex")
  set(BIN_FILE "${OUTPUT_DIR}/cf4a_gp_targetapp.bin")

  # Generate .elf file
  add_custom_command(TARGET target_app_swc POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_DIR}
      COMMAND ${CMAKE_COMMAND} -E touch ${ELF_FILE}
      COMMAND ${CMAKE_OBJCOPY} -O elf32-littlearm $<TARGET_FILE:target_app_swc> ${ELF_FILE}
      COMMENT "Generating .elf file"
  )

  # Generate .hex and .bin files
  add_custom_command(TARGET target_app_swc POST_BUILD
      COMMAND ${CMAKE_OBJCOPY} -O ihex ${ELF_FILE} ${HEX_FILE}
      COMMAND ${CMAKE_OBJCOPY} -O binary ${ELF_FILE} ${BIN_FILE}
      COMMENT "Generating .hex and .bin files"
  )

  # Install .elf, .hex, and .bin files if it's not the first build
  if(NOT FIRST_BUILD)
      install(FILES ${ELF_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_targetapp.elf)
      install(FILES ${HEX_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_targetapp.hex)
      install(FILES ${BIN_FILE} DESTINATION ${OUTPUT_DIR} RENAME cf4a_gp_targetapp.bin)
  endif()

elseif (MODE STREQUAL "TESTING")
  include(tools/cmake/target_app_swc_tests.cmake)
  add_executable(target_app_swc_test ${target_app_swc_tests_sources_list})
endif()
