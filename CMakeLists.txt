cmake_minimum_required(VERSION 3.10)

project(cf4a_gp_app)

include(CTest)
include("${CMAKE_PROJECT_DIR}/user.cmake")

# Building BSW
add_subdirectory("${bsw_dir}")

# Building Application
add_subdirectory("${application_dir}")