macro (erl_config_open3d)
    erl_find_package(
        PACKAGE Open3D #
        REQUIRED #
        COMMANDS GENERAL "visit http://www.open3d.org/" #
        COMMANDS ARCH_LINUX "try `paru -S open3d`")
    # Open3DConfig.cmake does not set Open3D_INCLUDE_DIRS correctly when some dependencies are installed at /usr/include
    # while Open3D is installed at /usr/local/include. And Open3D_INCLUDE_DIRS set by Open3DConfig.cmake does not
    # include path to 3rd-party dependencies like Eigen3, which is required by Open3D.
    get_target_property(Open3D_INCLUDE_DIRS Open3D::Open3D INTERFACE_INCLUDE_DIRECTORIES)
    message(STATUS "Open3D_INCLUDE_DIRS: ${Open3D_INCLUDE_DIRS}")
    if (ROS1_ACTIVATED)
        get_target_property(Open3D_LIBRARIES Open3D::Open3D LOCATION)
        message(STATUS "Open3D_LIBRARIES: ${Open3D_LIBRARIES}")
    endif ()
endmacro ()
