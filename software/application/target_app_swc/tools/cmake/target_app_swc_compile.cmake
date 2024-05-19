set(
    target_app_swc_sources_list

    ${target_app_swc}/core/main.c
    ${target_app_swc}/startup_stm32f103c8tx.c
    ${target_app_swc}/core/bootloader_prg.c
    ${target_app_swc}/core/system_stm32f1xx.c
    ${target_app_swc}/core/stm32f1xx_hal_msp.c
    ${target_app_swc}/core/stm32f1xx_it.c
    ${target_app_swc}/core/crc.c
    ${target_app_swc}/core/gpio.c
    ${target_app_swc}/core/rtc.c
    ${target_app_swc}/core/syscalls.c
    ${target_app_swc}/core/sysmem.c
    ${target_app_swc}/core/usart.c
)

set(
    target_app_swc_includes

    ${target_app_swc}/core
    ${common_platform_includes}
    ${common_asset_includes}
    ${hal_drivers}/include
)

set(
    target_app_swc_compile_options
)

set(
    target_app_swc_defines
)

set(
    target_app_swc_libs
    
    "hal_drivers"
    "-T ${target_app_swc}/stm32f103c8t6.lds"
)

    