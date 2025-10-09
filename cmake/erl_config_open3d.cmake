macro(erl_config_open3d)
    erl_find_package(
        PACKAGE Open3D
        REQUIRED
        COMMANDS GENERAL "visit http://www.open3d.org/"
        COMMANDS ARCH_LINUX "try `paru -S open3d`")
    # Open3DConfig.cmake does not set Open3D_INCLUDE_DIRS correctly when some dependencies are installed at /usr/include
    # while Open3D is installed at /usr/local/include. And Open3D_INCLUDE_DIRS set by Open3DConfig.cmake does not
    # include path to 3rd-party dependencies like Eigen3, which is required by Open3D.
    get_target_property(include_dirs Open3D::Open3D INTERFACE_INCLUDE_DIRECTORIES)
    get_target_property(lib_dirs Open3D::Open3D LOCATION)
    set(Open3D_INCLUDE_DIRS ${include_dirs} CACHE PATH "Open3D include directories" FORCE)
    set(Open3D_LIBRARIES ${lib_dirs} CACHE FILEPATH "Open3D library" FORCE)
    unset(include_dirs)
    unset(lib_dirs)
    # Don't use Open3D::Open3D directly, because it may cause cmake errors when we link Open3D::Open3D to a target A and
    # then link A to another target B from a different project.
    # On ArchLinux, this issues does not exist, but on Ubuntu, it does.
    message(STATUS "Open3D_INCLUDE_DIRS: ${Open3D_INCLUDE_DIRS}")
    message(STATUS "Open3D_LIBRARIES: ${Open3D_LIBRARIES}")
    add_compile_definitions(ERL_USE_OPEN3D)
endmacro()
