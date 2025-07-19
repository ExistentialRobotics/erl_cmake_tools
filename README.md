erl_cmake_tools
============

This is a CMake module that provides some utilities for configuring C++ projects developed in ERL.

# Getting Started

1. Clone this repository into your project's `src` directory
    ```shell
    cd src
    git clone https://github.com/ExistentialRobotics/erl_cmake_tools.git
    ```
2. Include the module in your project's `CMakeLists.txt` file
    ```cmake
    add_subdirectory(src/erl_cmake_tools)
    ```
    Or in the `CMakeLists.txt` of your ROS package:
    ```cmake
    if (NOT COMMAND erl_project_setup)
        find_package(erl_cmake_tools REQUIRED)
    endif ()
    ```
    and in the `package.xml`, add the buildtool dependency:
    ```xml
    <buildtool_depend>erl_cmake_tools</buildtool_depend>
    ```
3. Then, you can use the utilities provided by `erl_cmake_tools` in other `CMakeLists.txt`.
   For example:
    ```cmake
    cmake_minimum_required(VERSION 3.24)

    project(erl_covariance
            LANGUAGES CXX
            VERSION 0.1.0
            DESCRIPTION "erl_covariance is a C++ library of kernel functions")
    message(STATUS "Configuring ${PROJECT_NAME} ${PROJECT_VERSION}")

    if (NOT COMMAND erl_project_setup)
       find_package(erl_cmake_tools REQUIRED)
    endif ()
    erl_project_setup()
    erl_setup_ros()
    # ...
    ```
   Full example can be found
   in [erl_covariance](https://github.com/ExistentialRobotics/erl_covariance/blob/main/CMakeLists.txt).

# Utilities

## erl_project_setup

This is a macro that does the following things:

- Detect ROS environment: call `erl_detect_ros`
- Setup compiler flags: call `erl_setup_compiler`
- Setup Python: call `erl_setup_python`
- Setup test: call `erl_setup_test`
- Setup project paths: call `erl_set_project_paths`
- Find required ERL packages if specified

Options:
- `ENABLE_CUDA`: Enable CUDA support
- `ERL_PACKAGES`: List of ERL packages to find

## erl_setup_ros

This is a macro that supports both ROS1 and ROS2:

- For ROS1: finds catkin with required catkin components, sets up Python for catkin if `setup.py` is found
- For ROS2: sets up ROS2 environment and components
- Supports message generation with MSG_FILES, SRV_FILES, ACTION_FILES
- Handles dependencies with CATKIN_COMPONENTS, CATKIN_DEPENDS, ROS2_COMPONENTS

## erl_add_ros_src

This is a macro that includes ROS-specific source configuration:

- For ROS1: includes `src/ros1/ros.cmake` if it exists
- For ROS2: includes `src/ros2/ros.cmake` if it exists
- Provides warnings if ROS is not activated or configuration files don't exist

## erl_target_dependencies

This is a function that automatically links targets with ERL package dependencies:

- Links with ERL packages specified in `${PROJECT_NAME}_ERL_PACKAGES`
- Supports additional dependencies via unparsed arguments
- Handles ROS1 catkin includes and libraries
- Supports ROS2 message linking with `LINK_MSGS` option to link the ${PROJECT_NAME}_msgs target

## erl_add_pybind_module

This is a macro that creates Python binding modules using pybind11:

- Creates pybind11 module from C++ sources in specified directory
- Handles include directories and library linking
- Sets up proper RPATH for portability
- Supports custom module names and source directories

Options:
- `PYBIND_MODULE_NAME`: Name of the pybind11 module
- `PYBIND_SRC_DIR`: Source directory containing .cpp files
- `INCLUDE_DIRS`: Additional include directories
- `LIBRARIES`: Libraries to link against

## erl_add_python_package

This is a macro that sets up Python package build targets:

- Creates custom targets: `<project_name>_py_wheel`, `<project_name>_py_develop`, `<project_name>_py_install`
- Optionally creates stub generation target: `<project_name>_py_stub`
- Requires `setup.py` in project root directory
- Supports user installation mode with `ERL_PYTHON_INSTALL_USER` option

## erl_add_tests

This is a macro that automatically detects and adds GoogleTest tests:

- Scans `test/gtest/*.cpp` files for test sources
- Supports excluding specific test files with `erl_ignore_gtest`
- Links with specified libraries
- Supports custom GTest arguments and working directories

Options:
- `LIBRARIES`: Libraries to link test executables against
- `EXCLUDE_FROM_ALL`: Exclude tests from default build target

## erl_find_package

This is a macro that finds packages with platform-specific installation suggestions:

- Supports standard CMake find_package and pkg-config modes
- Prints helpful installation commands for different platforms
- Handles REQUIRED, QUIET, and NO_RECORD options

Options:
- `PACKAGE`: Package name to find
- `REQUIRED`: Make package required
- `QUIET`: Suppress verbose output
- `NO_RECORD`: Don't record package as dependency
- `PKGCONFIG`: Use pkg-config instead of find_package
- `COMMANDS`: Platform-specific installation suggestions

Example:
```cmake
erl_find_package(
    PACKAGE OpenMP
    REQUIRED
    COMMANDS APPLE "try `brew install libomp`"
    COMMANDS UBUNTU_LINUX "try `sudo apt install libomp-dev`"
    COMMANDS ARCH_LINUX "try `sudo pacman -S openmp`")
```

## erl_find_path

This is a function to find directories containing required files with installation suggestions:

- Finds paths using standard CMake find_path
- Provides platform-specific installation suggestions when not found
- Supports custom output variable names

Options:
- `OUTPUT`: Variable name for output (default: FILE_FOUND)
- `PACKAGE`: Package name for messaging
- `COMMANDS`: Platform-specific installation suggestions

Example:
```cmake
erl_find_path(
    OUTPUT LAPACKE_INCLUDE_DIR
    PACKAGE LAPACKE
    NAMES lapacke.h
    PATHS /usr/include /usr/local/include
    COMMANDS UBUNTU_LINUX "try `sudo apt install liblapacke-dev`"
    COMMANDS ARCH_LINUX "try `sudo pacman -S lapacke`")
```

## erl_install

This is a macro that generates comprehensive install rules:

- Installs executables, libraries, header files, and other files
- Handles Python modules and ROS-specific installations
- Creates proper CMake export targets for libraries
- Supports both ROS1 (catkin) and ROS2 (ament) install patterns

Options:
- `EXECUTABLES`: List of executable targets to install
- `LIBRARIES`: List of library targets to install
- `PYBIND_MODULES`: List of Python binding modules to install
- `CATKIN_PYTHON_PROGRAMS`: ROS1-specific Python programs
- `OTHER_FILES`: Additional files to install

Example:
```cmake
erl_install(
    EXECUTABLES ${${PROJECT_NAME}_COLLECTED_EXECUTABLES}
    LIBRARIES ${${PROJECT_NAME}_COLLECTED_LIBRARIES}
    PYBIND_MODULES py${PROJECT_NAME})
```

## erl_mark_project_found

This is a macro that marks the current project as found and finalizes the build:

- Sets `${PROJECT_NAME}_FOUND` to TRUE
- For ROS2: calls `ament_package()` with proper CONFIG_EXTRAS
- Handles configuration extras for both ROS1 and ROS2

## Utility Functions

### erl_detect_ros
Detects ROS environment and sets ROS1_ACTIVATED or ROS2_ACTIVATED variables based on environment.

### erl_setup_compiler
Sets up compiler flags including:
- C++17 standard
- OpenMP support
- Warning flags (-Wall, -Wextra)
- Optimization flags for different build types
- ccache support if available
- Platform-specific settings

### erl_enable_cuda
Enables CUDA language support with proper compiler settings and flags.

### erl_setup_python
Sets up Python build options and configures `ERL_BUILD_PYTHON_${PROJECT_NAME}` variable.

### erl_setup_test
Sets up testing options and configures `ERL_BUILD_TEST_${PROJECT_NAME}` variable.

### erl_set_project_paths
Sets up standard project directory paths for both build and install destinations, with ROS1/ROS2 specific paths.

### erl_os_release_info
Gets OS release information including distribution name, version, and codename from system files.

### erl_parse_key_value_pairs
Parses key-value pairs from a list and sets variables with a given prefix.

### erl_platform_based_message
Prints messages based on the current platform (Linux distribution, macOS, etc.).

### erl_suggest_cmd_for_assert
Suggests platform-specific commands when assertions fail.

### erl_print_variables
Prints all CMake variables for debugging purposes.

### erl_print_variable
Prints a specific CMake variable value for debugging.

### erl_collect_targets
Collects targets of a specific type for later processing.

### erl_ignore_gtest
Adds files to the GTest ignore list.

### erl_set_gtest_args
Sets custom arguments for specific GTest executables.

### erl_set_gtest_extra_libraries
Sets additional libraries for specific GTest executables.

### erl_set_gtest_working_directory
Sets working directory for specific GTest executables.

### erl_append_property
Appends target properties to an output variable.

### erl_collect_library_dependencies
Recursively collects library dependencies and include directories.
