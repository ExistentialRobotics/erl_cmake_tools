macro(erl_config_libzip)
    option(ERL_USE_LIBZIP "Use libzip" ON)
    if (ERL_USE_LIBZIP)
        erl_find_package(
            PACKAGE libzip
            REQUIRED PKGCONFIG libzip
            COMMANDS ARCH_LINUX "try `sudo pacman -S libzip`"
            COMMANDS UBUNTU_LINUX "try `sudo apt-get install libzip-dev`"
            
        )

        add_compile_definitions(ERL_USE_LIBZIP)
    endif ()
endmacro()
