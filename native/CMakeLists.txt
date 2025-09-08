cmake_minimum_required(VERSION 3.10)
project(spotitml_native)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ONNX Runtime configuration - use system-installed packages
if(ANDROID)
    # Android: Use prebuilt AAR from Maven (configured in build.gradle)
    # The AAR provides headers and native libraries automatically
    find_path(ONNXRUNTIME_INCLUDE_DIRS
        NAMES onnxruntime_cxx_api.h
        PATHS ${CMAKE_ANDROID_NDK}/sources/cxx-stl/llvm-libc++/include
              ${CMAKE_SYSROOT}/usr/include
    )
    find_library(ONNXRUNTIME_LIB
        NAMES onnxruntime
        PATHS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    )
elseif(APPLE)
    # macOS: Use Homebrew installation
    find_path(ONNXRUNTIME_INCLUDE_DIRS
        NAMES onnxruntime_cxx_api.h
        PATHS /usr/local/opt/onnxruntime/include/onnxruntime
              /opt/homebrew/opt/onnxruntime/include/onnxruntime
              /usr/local/include/onnxruntime
              /opt/homebrew/include/onnxruntime
    )
    find_library(ONNXRUNTIME_LIB
        NAMES onnxruntime
        PATHS /usr/local/opt/onnxruntime/lib
              /opt/homebrew/opt/onnxruntime/lib
              /usr/local/lib
              /opt/homebrew/lib
    )
else()
    message(FATAL_ERROR "Platform not yet supported. Android and macOS only.")
endif()

# Verify ONNX Runtime was found
if(NOT ONNXRUNTIME_INCLUDE_DIRS OR NOT ONNXRUNTIME_LIB)
    if(APPLE)
        message(FATAL_ERROR "ONNX Runtime not found. Install with: brew install onnxruntime")
    else()
        message(FATAL_ERROR "ONNX Runtime not found. Check build.gradle Maven dependency.")
    endif()
endif()

message(STATUS "Found ONNX Runtime: ${ONNXRUNTIME_LIB}")
message(STATUS "ONNX Runtime includes: ${ONNXRUNTIME_INCLUDE_DIRS}")

add_library(spotitml_native SHARED
    src/spotitml_native.cpp
)

target_include_directories(spotitml_native
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
    PRIVATE ${ONNXRUNTIME_INCLUDE_DIRS}
)

# Link ONNX Runtime library
target_link_libraries(spotitml_native PRIVATE ${ONNXRUNTIME_LIB})

# Bundle ONNX Runtime for macOS app sandbox compatibility
if(APPLE)
    # Configure RPATH for our library to find co-located dependencies
    set_target_properties(spotitml_native PROPERTIES
        INSTALL_RPATH "@loader_path"
        BUILD_WITH_INSTALL_RPATH TRUE
    )
    
    # Bundle ONNX Runtime alongside our library
    add_custom_command(TARGET spotitml_native POST_BUILD
        # Step 1: Copy ONNX Runtime library to our build directory
        COMMAND ${CMAKE_COMMAND} -E copy ${ONNXRUNTIME_LIB} $<TARGET_FILE_DIR:spotitml_native>/libonnxruntime.1.22.2.dylib
        
        # Step 2: Fix the dependency path in our library using install_name_tool
        # Problem: Our library was linked with absolute path "/usr/local/opt/onnxruntime/lib/libonnxruntime.1.22.2.dylib"
        # Solution: Change it to relative path "@rpath/libonnxruntime.1.22.2.dylib"
        # Why: @rpath means "look in the same directory as this library" (due to INSTALL_RPATH "@loader_path")
        # Result: App sandbox can find the bundled ONNX Runtime instead of system location
        COMMAND install_name_tool -change 
            "/usr/local/opt/onnxruntime/lib/libonnxruntime.1.22.2.dylib"
            "@rpath/libonnxruntime.1.22.2.dylib"
            $<TARGET_FILE:spotitml_native>
            
        # Step 3: Code sign both libraries for macOS app distribution
        COMMAND codesign --force --sign - $<TARGET_FILE_DIR:spotitml_native>/libonnxruntime.1.22.2.dylib
        COMMAND codesign --force --sign - $<TARGET_FILE:spotitml_native>
        COMMENT "Bundle ONNX Runtime with @rpath linking for app sandbox compatibility"
    )
endif()


