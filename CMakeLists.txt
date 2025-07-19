cmake_minimum_required(VERSION 3.16)

project(
    erl_cmake_tools
    VERSION 0.1.0
    DESCRIPTION
        "erl_cmake_tools is a collection of CMake helper functions and macros for Existential Robotics Library (ERL) packages."
)
message(STATUS "Configuring ${PROJECT_NAME} ${PROJECT_VERSION}")

include(cmake/erl_cmake_tools.cmake)
erl_project_setup()
erl_setup_ros(CFG_EXTRAS erl_cmake_tools.cmake)
erl_install()
erl_mark_project_found()
