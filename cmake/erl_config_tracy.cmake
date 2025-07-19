macro (erl_config_tracy)
    option(ERL_USE_TRACY "Use Tracy Profiler" OFF)
    option(ERL_TRACY_PROFILE_MEMORY "Profile memory usage" OFF)
    if (ERL_USE_TRACY)
        set(TRACY_ENABLE ON)
        if (ERL_TRACY_PROFILE_MEMORY)
            add_compile_definitions(ERL_TRACY_PROFILE_MEMORY)
        endif ()

        set(BUILD_SHARED_LIBS ON)
        file(REMOVE_RECURSE ${CMAKE_BINARY_DIR}/_deps/imgui-src) # delete folder
        file(REMOVE_RECURSE ${CMAKE_BINARY_DIR}/_deps/imgui-subbuild) # delete folder
        add_subdirectory(deps/tracy SYSTEM)
        set(LEGACY ON) # use X11 for Tracy
        add_subdirectory(deps/tracy/profiler SYSTEM)
        target_compile_options(TracyClient PRIVATE -w) # disable warnings for Tracy
        target_compile_options(TracyServer PRIVATE -w) # disable warnings for Tracy
        target_compile_options(tracy-profiler PRIVATE -w) # disable warnings for Tracy
        erl_find_package(
            PACKAGE TBB REQUIRED #
            COMMANDS UBUNTU_LINUX "try `sudo apt install libtbb-dev`" #
            COMMANDS ARCH_LINUX "try `sudo pacman -S onetbb`")
        target_link_libraries(tracy-profiler PRIVATE TBB::tbb)
        link_libraries(Tracy::TracyClient) # link Tracy to all targets
    endif ()
endmacro ()
