cmake_minimum_required(VERSION 3.10)
project(spotitml)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include Conan-generated configurations
include(${CMAKE_BINARY_DIR}/conan_paths.cmake OPTIONAL RESULT_VARIABLE CONAN_PATHS_EXISTS)
if(NOT CONAN_PATHS_EXISTS)
    message(FATAL_ERROR "The file conan_paths.cmake doesn't exist, you must run conan install first")
endif()

find_package(onnxruntime REQUIRED)
find_package(GTest REQUIRED)

# Main library
add_library(spotitml SHARED
    src/ml/onnx_runner.cpp
    src/utils/logger.cpp
)

target_include_directories(spotitml PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${onnxruntime_INCLUDE_DIRS}
)

target_link_libraries(spotitml PUBLIC
    onnxruntime::onnxruntime
)

# Tests
option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()