# set(COMMON_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft -mfloat-abi=soft -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -Og -ffunction-sections -fdata-sections -g -gdwarf-3 -gstrict-dwarf -Wall")
set(COMMON_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -Og -ffunction-sections -fdata-sections -g -gdwarf-3 -gstrict-dwarf -Wall")
set(STM32F103C8_FLAGS "-mthumb-interwork -march=armv7-m -mfix-cortex-m3-ldrd -mlittle-endian -mthumb -mcpu=cortex-m3 -mfloat-abi=soft -mfpu=vfp -msoft-float -nostdlib -nostartfiles -fno-exceptions -fno-common")

set(CMAKE_C_FLAGS          "${COMMON_FLAGS} ${STM32F103C8_FLAGS}")
set(CMAKE_CXX_FLAGS        "${COMMON_FLAGS} ${STM32F103C8_FLAGS}")

set(CMAKE_C_COMPILER       ${TOOLCHAIN_DIR}/bin/arm-eabi-gcc)
set(CMAKE_CXX_COMPILER     ${TOOLCHAIN_DIR}/bin/arm-eabi-gcc)
set(CMAKE_AR               ${TOOLCHAIN_DIR}/bin/arm-eabi-ar)
set(COMPILER_OBJCOPY       ${TOOLCHAIN_DIR}/bin/arm-eabi-objcopy)
set(COMPILER_OBJDUMP       ${TOOLCHAIN_DIR}/bin/arm-eabi-objdump)

set(LINKER_FLAGS "-Wl,--gc-sections -Wl,-Map=${SOFTWARE_COMPONENT}.map -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group -MMD -MP")

set(CMAKE_EXE_LINKER_FLAGS "${LINKER_FLAGS}")

set(CMAKE_C_CREATE_STATIC_LIBRARY "<CMAKE_AR> -crs <TARGET> <LINK_FLAGS> <OBJECTS>")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)