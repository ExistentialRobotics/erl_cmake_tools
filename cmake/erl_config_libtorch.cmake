macro(erl_config_libtorch)
    option(ERL_USE_LIBTORCH "Use libtorch" OFF)
    if (ERL_USE_LIBTORCH)
        if (NOT DEFINED Torch_DIR)
            if (CMAKE_BUILD_TYPE STREQUAL "Debug")
                set(Torch_DIR /opt/libtorch-cuda-debug)
            else ()
                set(Torch_DIR /opt/libtorch-cuda-release)
            endif ()
            if (NOT EXISTS ${Torch_DIR})
                message(STATUS "BUILD_TYPE dependent libtorch is not found at ${Torch_DIR}, try another path")
                set(Torch_DIR /opt/libtorch-cuda)
            endif ()
            if (NOT EXISTS ${Torch_DIR})
                message(STATUS "BUILD_TYPE dependent libtorch is not found at ${Torch_DIR}, try another path")
                set(Torch_DIR /opt/libtorch)
            endif ()
            if (NOT EXISTS ${Torch_DIR})
                message(FATAL_ERROR "BUILD_TYPE dependent libtorch is not found at ${Torch_DIR}, please install it")
            endif ()
        endif ()

        if (NOT DEFINED CUSPARSELT_INCLUDE_PATH AND EXISTS /opt/cusparselt)
            set(CUSPARSELT_INCLUDE_PATH /opt/cusparselt/include)
        endif ()
        if (NOT DEFINED CUSPARSELT_LIBRARY_PATH AND EXISTS /opt/cusparselt)
            set(CUSPARSELT_LIBRARY_PATH /opt/cusparselt/lib/libcusparseLt.so)
        endif ()
         if (NOT EXISTS ${CUSPARSELT_INCLUDE_PATH})
             message(FATAL_ERROR "CUSPARSELT_INCLUDE_PATH not found at ${CUSPARSELT_INCLUDE_PATH}, please install it")
         endif ()
         if (NOT EXISTS ${CUSPARSELT_LIBRARY_PATH})
             message(FATAL_ERROR "CUSPARSELT_LIBRARY_PATH not found at ${CUSPARSELT_LIBRARY_PATH}, please install it")
         endif ()
        set(CAFFE2_USE_CUDNN ON)
        set(CAFFE2_USE_CUSPARSELT ON)
        # Don't care about the hash, set it so that Caffe2 doesn't complain and do stupid things
        set(CUDA_NVRTC_SHORTHASH "XXXXXXXX")
        set(USE_SYSTEM_NVTX ON)
        if (Torch_DIR MATCHES "site-packages")
            # .../site-packages/torch/share/cmake/Torch
            list(APPEND CMAKE_PREFIX_PATH "${Torch_DIR}/../../../../nvidia/nvtx")
            set(USE_ASAN ON)   # enable address sanitizer to prevent -fvisibility=hidden
        endif ()
        erl_find_package(
            PACKAGE Torch
            REQUIRED
            PATHS ${Torch_DIR} NO_DEFAULT_PATH
            COMMANDS GENERAL "visit https://pytorch.org/get-started/locally/ and follow the instructions"
            COMMANDS ARCH_LINUX "try `paru -S libtorch-cxx11abi-cuda`")
        list(APPEND TORCH_LIBRARIES CUDA::cupti)

        # <Torch_DIR>/share/cmake/Caffe2/public/cuda.cmake sets Python_FOUND which causes pybind11 to behave
        # incorrectly this should not be defined after we set CUDA_NVRTC_SHORTHASH before configuring Torch we still
        # check it here to avoid other stupid things in the future
        if (DEFINED Python_FOUND)
            unset(Python_FOUND)
        endif ()
        add_compile_definitions(ERL_USE_LIBTORCH)
    endif ()
endmacro()
