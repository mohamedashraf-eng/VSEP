set(
    bootloader_swc_sources_list

    ${bootloader_swc}/core/main.c
    ${bootloader_swc}/startup_stm32f103c8tx.c
    ${bootloader_swc}/core/bootloader_prg.c
    ${bootloader_swc}/core/system_stm32f1xx.c
    ${bootloader_swc}/core/stm32f1xx_hal_msp.c
    ${bootloader_swc}/core/stm32f1xx_it.c
    ${bootloader_swc}/core/crc.c
    ${bootloader_swc}/core/gpio.c
    ${bootloader_swc}/core/rtc.c
    ${bootloader_swc}/core/syscalls.c
    ${bootloader_swc}/core/sysmem.c
    ${bootloader_swc}/core/usart.c
    ${bootloader_swc}/core/fee_prg.c
)

set(
    bootloader_swc_includes

    ${bootloader_swc}/core
    ${common_platform_includes}
    ${common_asset_includes}
    ${hal_drivers}/include
)

set(
    bootloader_swc_compile_options
)

set(
    bootloader_swc_defines
)

set(
    bootloader_swc_libs
    
    "hal_drivers"
    "-T ${bootloader_swc}/stm32f103c8t6.lds"
)

    