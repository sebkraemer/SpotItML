cmake_minimum_required(VERSION 3.10)
project(spotitml_native)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ONNX Runtime configuration
if(APPLE)
    # macOS development
    set(ONNXRUNTIME_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/onnxruntime-osx-x64-1.22.0)
    set(ONNXRUNTIME_LIB ${ONNXRUNTIME_ROOT}/lib/libonnxruntime.dylib)
else()
    # TODO: Add Android/Linux/Windows support later
    message(FATAL_ERROR "Platform not yet supported. Currently only macOS is implemented.")
endif()

set(ONNXRUNTIME_INCLUDE_DIRS "${ONNXRUNTIME_ROOT}/include")

add_library(spotitml_native SHARED
    src/spotitml_native.cpp
)

target_include_directories(spotitml_native
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
    PRIVATE ${ONNXRUNTIME_INCLUDE_DIRS}
)

# Link ONNX Runtime library (temporarily disabled for basic FFI test)
# target_link_libraries(spotitml_native PRIVATE ${ONNXRUNTIME_LIB})

# Copy and code sign libraries for macOS
if(APPLE)
    add_custom_command(TARGET spotitml_native POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${ONNXRUNTIME_LIB} $<TARGET_FILE_DIR:spotitml_native>/
        COMMAND codesign --force --sign - $<TARGET_FILE_DIR:spotitml_native>/libonnxruntime.dylib
        COMMAND codesign --force --sign - $<TARGET_FILE:spotitml_native>
        COMMENT "Copy and code sign libraries for CMake build"
    )
    
    # Also ensure libraries are available for Flutter app bundle
    # This will be triggered when Flutter builds the app
    set(FLUTTER_APP_DIR "${CMAKE_SOURCE_DIR}/../build/macos/Build/Products")
    add_custom_target(flutter_deploy ALL
        COMMAND ${CMAKE_COMMAND} -E copy ${ONNXRUNTIME_LIB} ${FLUTTER_APP_DIR}/Debug/spotitml.app/Contents/Frameworks/ 2>/dev/null || true
        COMMAND ${CMAKE_COMMAND} -E copy ${ONNXRUNTIME_LIB} ${FLUTTER_APP_DIR}/Release/spotitml.app/Contents/Frameworks/ 2>/dev/null || true
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:spotitml_native> ${FLUTTER_APP_DIR}/Debug/spotitml.app/Contents/Frameworks/ 2>/dev/null || true
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:spotitml_native> ${FLUTTER_APP_DIR}/Release/spotitml.app/Contents/Frameworks/ 2>/dev/null || true
        DEPENDS spotitml_native
        COMMENT "Deploy libraries to Flutter app bundle"
    )
endif()


