macro(erl_config_spot)
    erl_find_package(
        PACKAGE spot
        PKGCONFIG REQUIRED libspot  # available modules: libbddx libspot libspotgen libspotltsmin
        COMMANDS ARCH_LINUX "try `paru -S spot`"
        COMMANDS GENERAL "visit https://spot.lrde.epita.fr/install.html"
    )
    add_compile_definitions(ERL_USE_SPOT)
endmacro()
