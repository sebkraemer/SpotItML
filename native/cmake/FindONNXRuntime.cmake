# FindONNXRuntime.cmake
# Modern CMake module for ONNX Runtime integration
# 
# Creates imported targets:
#   onnxruntime::headers - Interface library with headers
#   onnxruntime::onnxruntime - Shared library with runtime
#
# Sets variables:
#   ONNXRuntime_FOUND - TRUE if ONNX Runtime was found
#   ONNXRuntime_VERSION - Version of ONNX Runtime

include(FetchContent)

# ONNX Runtime version configuration
set(ONNXRUNTIME_VERSION "1.22.0" CACHE STRING "ONNX Runtime version")

#
# Android: FetchContent approach with AAR download and extraction
#
function(_setup_onnxruntime_android)
    message(STATUS "🔍 Setting up ONNX Runtime ${ONNXRUNTIME_VERSION} for Android...")
    
    # Use FetchContent to handle ONNX Runtime AAR
    FetchContent_Declare(
        onnxruntime_aar
        URL https://repo1.maven.org/maven2/com/microsoft/onnxruntime/onnxruntime-android/${ONNXRUNTIME_VERSION}/onnxruntime-android-${ONNXRUNTIME_VERSION}.aar
        DOWNLOAD_NAME "onnxruntime-android.zip"  # Tricks CMake into URL mode
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
        message(FATAL_ERROR "❌ Unsupported Android ABI: ${ANDROID_ABI}")
    endif()
    
    message(STATUS "✅ ONNX Runtime configured for Android")
    message(STATUS "   Version: ${ONNXRUNTIME_VERSION}")
    message(STATUS "   ABI: ${ANDROID_ABI}")
    message(STATUS "   Headers: ${onnxruntime_aar_SOURCE_DIR}/headers")
    message(STATUS "   Library: ${onnxruntime_aar_SOURCE_DIR}/jni/${ANDROID_ABI}/libonnxruntime.so")
endfunction()

#
# macOS: System-installed ONNX Runtime via Homebrew
#
function(_setup_onnxruntime_macos)
    message(STATUS "🔍 Setting up ONNX Runtime for macOS...")
    
    # Find system-installed ONNX Runtime
    find_path(ONNXRUNTIME_INCLUDE_DIRS NAMES onnxruntime_cxx_api.h
        PATHS /usr/local/opt/onnxruntime/include/onnxruntime
              /opt/homebrew/opt/onnxruntime/include/onnxruntime
              /usr/local/include/onnxruntime
              /opt/homebrew/include/onnxruntime
        DOC "ONNX Runtime include directory")
        
    find_library(ONNXRUNTIME_LIB NAMES onnxruntime
        PATHS /usr/local/opt/onnxruntime/lib
              /opt/homebrew/opt/onnxruntime/lib
              /usr/local/lib
              /opt/homebrew/lib
        DOC "ONNX Runtime library")
    
    if(NOT ONNXRUNTIME_INCLUDE_DIRS OR NOT ONNXRUNTIME_LIB)
        message(FATAL_ERROR "❌ ONNX Runtime not found. Install with: brew install onnxruntime")
    endif()
    
    # Create imported targets for consistency with Android
    add_library(onnxruntime::headers INTERFACE IMPORTED)
    target_include_directories(onnxruntime::headers INTERFACE "${ONNXRUNTIME_INCLUDE_DIRS}")
    
    add_library(onnxruntime::onnxruntime UNKNOWN IMPORTED)
    set_target_properties(onnxruntime::onnxruntime PROPERTIES IMPORTED_LOCATION "${ONNXRUNTIME_LIB}")
    
    message(STATUS "✅ ONNX Runtime configured for macOS")
    message(STATUS "   Headers: ${ONNXRUNTIME_INCLUDE_DIRS}")
    message(STATUS "   Library: ${ONNXRUNTIME_LIB}")
endfunction()

#
# Main ONNX Runtime setup - automatically detects platform
#
if(ANDROID)
    _setup_onnxruntime_android()
elseif(APPLE)
    _setup_onnxruntime_macos()
else()
    message(FATAL_ERROR "❌ Platform not supported. ONNX Runtime module supports Android and macOS only.")
endif()

# Set standard CMake variables
set(ONNXRuntime_FOUND TRUE)
set(ONNXRuntime_VERSION "${ONNXRUNTIME_VERSION}")

# Provide usage summary
message(STATUS "📋 ONNX Runtime Summary:")
message(STATUS "   Found: ${ONNXRuntime_FOUND}")
message(STATUS "   Version: ${ONNXRuntime_VERSION}")
message(STATUS "   Platform: ${CMAKE_SYSTEM_NAME}")
message(STATUS "   Targets: onnxruntime::headers, onnxruntime::onnxruntime")