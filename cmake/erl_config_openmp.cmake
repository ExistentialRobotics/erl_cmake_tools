macro(erl_config_openmp)
    if (APPLE)
        # -Xclang -fopenmp -L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include -lomp
        erl_find_path(
            OpenMP_INCLUDE_DIRS
            NAMES omp.h
            PATHS /opt/homebrew/opt/libomp/include
            COMMANDS DARWIN "try `brew install libomp`")
        set(OpenMP_LIBRARIES /opt/homebrew/opt/libomp/lib/libomp.dylib)
        set(OpenMP_CXX_FLAGS "-I/opt/homebrew/opt/libomp/include")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    else ()
        erl_find_package(
            PACKAGE OpenMP
            REQUIRED
            COMMANDS DARWIN "try `brew install libomp`"
            COMMANDS UBUNTU_LINUX "try `sudo apt install libomp-dev`"
            COMMANDS ARCH_LINUX "try `sudo pacman -S openmp`")

        if (ROS1_ACTIVATED)
            set(OpenMP_INCLUDE_DIRS /usr/include)
            message(STATUS "OpenMP_INCLUDE_DIRS: ${OpenMP_INCLUDE_DIRS}")
        endif ()

        get_target_property(OpenMP_LIBRARIES OpenMP::OpenMP_CXX INTERFACE_LINK_LIBRARIES)
        message(STATUS "OpenMP_LIBRARIES: ${OpenMP_LIBRARIES}")
        message(STATUS "OpenMP_CXX_FLAGS: ${OpenMP_CXX_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    endif ()
endmacro()
