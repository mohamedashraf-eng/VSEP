set(
    bootloader_swc_tests_sources_list

    ${bootloader_swc}/tests/unit/test_bootloader_swc.c

    # Any mocked file will be under ${MOCK_FILE_PATH}/mocks/mock_headerFileName.c
    # ${MOCK_FILE_PATH}/mocks/mock_Det.c
    # Include Test Runners 
    ${bootloader_swc}/tests/unit/test_runners/test_main.c
    ${bootloader_swc}/tests/unit/test_runners/test_runner.c
)

set(
    bootloader_swc_ut_sources_list
    
    # ${bootloader_swc}/core/main.c
    # ${bootloader_swc}/startup_stm32f103c8tx.c
    ${bootloader_swc}/core/bootloader_prg.c
    # ${bootloader_swc}/core/system_stm32f1xx.c
    # ${bootloader_swc}/core/stm32f1xx_hal_msp.c
    # ${bootloader_swc}/core/stm32f1xx_it.c
    # ${bootloader_swc}/core/crc.c
    # ${bootloader_swc}/core/gpio.c
    # ${bootloader_swc}/core/rtc.c
    # ${bootloader_swc}/core/syscalls.c
    # ${bootloader_swc}/core/sysmem.c
    # ${bootloader_swc}/core/usart.c
)

set (
    bootloader_swc_mock_header_files

)

set(
    bootloader_swc_tests_includes

    ${bootloader_swc}/core
    ${common_platform_includes}
    ${common_asset_includes}
    ${stubs}
    ${bootloader_swc}/tests/unit/stubs
    ${MOCK_FILE_PATH}/mocks/
)

set(
    bootloader_swc_tests_compile_options

)

set(
    bootloader_swc_tests_defines
)

set(
    bootloader_swc_tests_libs

    "bootloader_swc"
)
