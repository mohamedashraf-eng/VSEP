set(
    hal_drivers_tests_sources_list

    ${hal_drivers}/tests/unit/test_hal_drivers.c

    # Any mocked file will be under ${MOCK_FILE_PATH}/mocks/mock_headerFileName.c
    # ${MOCK_FILE_PATH}/mocks/mock_Det.c
    # Include Test Runners 
    ${hal_drivers}/tests/unit/test_runners/test_main.c
    ${hal_drivers}/tests/unit/test_runners/test_runner.c
)

set(
    hal_drivers_ut_sources_list
    
    ${hal_drivers}/src/stm32f1xx_hal_uart.c
)

set (
    hal_drivers_mock_header_files

)

set(
    hal_drivers_tests_includes

    ${hal_drivers}/include
    ${common_platform_includes}
    ${common_asset_includes}
    ${stubs}
    ${hal_drivers}/tests/unit/stubs
    ${MOCK_FILE_PATH}/mocks/
)

set(
    hal_drivers_tests_compile_options

)

set(
    hal_drivers_tests_defines
)

set(
    hal_drivers_tests_libs

    "hal_drivers"
)
