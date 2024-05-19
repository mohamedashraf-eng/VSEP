set(
    hal_drivers_sources_list

    ${hal_drivers}/src/stm32f1xx_hal_tim.c
    ${hal_drivers}/src/stm32f1xx_hal_tim_ex.c
    ${hal_drivers}/src/stm32f1xx_hal_cortex.c
    ${hal_drivers}/src/stm32f1xx_hal_crc.c
    ${hal_drivers}/src/stm32f1xx_hal_dma.c
    ${hal_drivers}/src/stm32f1xx_hal_exti.c
    ${hal_drivers}/src/stm32f1xx_hal_flash_ex.c
    ${hal_drivers}/src/stm32f1xx_hal_flash.c
    ${hal_drivers}/src/stm32f1xx_hal_gpio_ex.c
    ${hal_drivers}/src/stm32f1xx_hal_gpio.c
    ${hal_drivers}/src/stm32f1xx_hal_pwr.c
    ${hal_drivers}/src/stm32f1xx_hal_rcc_ex.c
    ${hal_drivers}/src/stm32f1xx_hal_rcc.c
    ${hal_drivers}/src/stm32f1xx_hal_rtc_ex.c
    ${hal_drivers}/src/stm32f1xx_hal_rtc.c
    ${hal_drivers}/src/stm32f1xx_hal_uart.c
    ${hal_drivers}/src/stm32f1xx_hal.c
)

set(
    hal_drivers_includes

    ${hal_drivers}/include
    ${common_platform_includes}
    ${common_asset_includes}
)

set(
    hal_drivers_compile_options
)

set(
    hal_drivers_defines
)