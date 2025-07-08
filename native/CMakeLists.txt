cmake_minimum_required(VERSION 3.10)
project(spotitml_native)

add_library(spotitml_native SHARED
    src/spotitml_native.cpp
)

target_include_directories(spotitml_native
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# flutter ffi needs the library at expected location and signed
if(APPLE)
  add_custom_command(TARGET spotitml_native POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
      $<TARGET_FILE:spotitml_native>
      ${CMAKE_SOURCE_DIR}/../build/macos/Build/Products/Debug/spotitml.app/Contents/Frameworks/
    COMMAND codesign --force --sign - ${CMAKE_SOURCE_DIR}/../build/macos/Build/Products/Debug/spotitml.app/Contents/Frameworks/libspotitml_native.dylib
    COMMENT "Copying and code signing libspotitml_native.dylib for Flutter macOS app"
  )
endif()


