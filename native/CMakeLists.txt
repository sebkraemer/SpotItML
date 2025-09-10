cmake_minimum_required(VERSION 3.10)
project(spotitml_native)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# FetchContent approach for ONNX Runtime Android
include(FetchContent)

function(setup_onnxruntime_android)
    # Use FetchContent to handle ONNX Runtime AAR
    FetchContent_Declare(
        onnxruntime_aar
        URL https://repo1.maven.org/maven2/com/microsoft/onnxruntime/onnxruntime-android/1.22.0/onnxruntime-android-1.22.0.aar
        DOWNLOAD_NAME "onnxruntime-android.zip"  # Tricks CMake into URL mode, avoids error "At least one entry of URL is a path (invalid in a list)"
        DOWNLOAD_EXTRACT_TIMESTAMP ON
    )
    
    FetchContent_MakeAvailable(onnxruntime_aar)
    
    # Create imported targets
    add_library(onnxruntime::headers INTERFACE IMPORTED)
    target_include_directories(onnxruntime::headers INTERFACE "${onnxruntime_aar_SOURCE_DIR}/headers")
    
    add_library(onnxruntime::onnxruntime SHARED IMPORTED)
    if(ANDROID_ABI MATCHES "^(arm64-v8a|armeabi-v7a|x86|x86_64)$")
        set_target_properties(onnxruntime::onnxruntime PROPERTIES
            IMPORTED_LOCATION "${onnxruntime_aar_SOURCE_DIR}/jni/${ANDROID_ABI}/libonnxruntime.so")
    else()
        message(FATAL_ERROR "Unsupported Android ABI: ${ANDROID_ABI}")
    endif()
endfunction()

function(setup_onnxruntime_macos)
    # Find system-installed ONNX Runtime
    find_path(ONNXRUNTIME_INCLUDE_DIRS NAMES onnxruntime_cxx_api.h
        PATHS /usr/local/opt/onnxruntime/include/onnxruntime
              /opt/homebrew/opt/onnxruntime/include/onnxruntime
              /usr/local/include/onnxruntime
              /opt/homebrew/include/onnxruntime
        REQUIRED)
    find_library(ONNXRUNTIME_LIB NAMES onnxruntime
        PATHS /usr/local/opt/onnxruntime/lib
              /opt/homebrew/opt/onnxruntime/lib
              /usr/local/lib
              /opt/homebrew/lib
        REQUIRED)
    
    # Create imported targets
    add_library(onnxruntime::headers INTERFACE IMPORTED)
    target_include_directories(onnxruntime::headers INTERFACE "${ONNXRUNTIME_INCLUDE_DIRS}")
    
    add_library(onnxruntime::onnxruntime UNKNOWN IMPORTED)
    set_target_properties(onnxruntime::onnxruntime PROPERTIES IMPORTED_LOCATION "${ONNXRUNTIME_LIB}")
endfunction()

# Unified ONNX Runtime setup
if(ANDROID)
    message(STATUS "🔍 Setting up ONNX Runtime for Android...")
    setup_onnxruntime_android()
    message(STATUS "✅ ONNX Runtime configured for Android")
elseif(APPLE)
    message(STATUS "🔍 Setting up ONNX Runtime for macOS...")  
    setup_onnxruntime_macos()
    message(STATUS "✅ ONNX Runtime configured for macOS")
else()
    message(FATAL_ERROR "❌ Platform not supported. Android and macOS only.")
endif()

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


