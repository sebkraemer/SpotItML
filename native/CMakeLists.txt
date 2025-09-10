cmake_minimum_required(VERSION 3.10)
project(spotitml_native)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ONNX Runtime integration via custom CMake module
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
find_package(ONNXRuntime REQUIRED)

add_library(spotitml_native SHARED
    src/spotitml_native.cpp
)

target_include_directories(spotitml_native
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Link ONNX Runtime (required dependency)
target_link_libraries(spotitml_native PRIVATE 
    onnxruntime::headers 
    onnxruntime::onnxruntime
)
target_compile_definitions(spotitml_native PRIVATE -DHAS_ONNXRUNTIME=1)
message(STATUS "🎯 ONNX Runtime: Linked successfully")

if(APPLE)
    add_custom_command(TARGET spotitml_native POST_BUILD
        COMMAND codesign --force --sign - $<TARGET_FILE:spotitml_native>
        COMMENT "Code sign native library"
    )
endif()


