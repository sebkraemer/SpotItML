# SpotItML Development Notes

## Current Status (Phase 1a - Partially Complete)

**What Works**: ✅ Basic Flutter + C++ FFI pipeline
- `hello_world()` → "Hello from C++!"
- `add_numbers(3, 4)` → 7
- `detect_objects(dummy_data)` → "Basic FFI working. Image: 640x480"

**What's Missing**: ❌ ONNX Runtime integration
- ONNX Runtime libraries configured but commented out
- YOLOv8n.onnx model download failed  
- Library deployment automation broken

## Manual Deployment Commands (Required After Each Build)

**After `flutter clean && flutter build macos`:**
```bash
# 1. Build native library
cd /Users/sebi/projects/SpotItML/native/build
make

# 2. Copy library to app bundle  
cp libspotitml_native.dylib /Users/sebi/projects/SpotItML/build/macos/Build/Products/Debug/spotitml.app/Contents/Frameworks/

# 3. Code sign library
codesign --force --sign - /Users/sebi/projects/SpotItML/build/macos/Build/Products/Debug/spotitml.app/Contents/Frameworks/libspotitml_native.dylib

# 4. Launch app
open /Users/sebi/projects/SpotItML/build/macos/Build/Products/Debug/spotitml.app
```

**For Release builds**, replace `Debug` with `Release` in paths.

## Next Steps Priority

### Phase 1a-bis: Build System Improvements (45 mins)
- **Problem 1**: CMake POST_BUILD commands don't integrate properly with Flutter build process
- **Problem 2**: 27MB+ ONNX Runtime binaries checked into repo (not ideal)

**Android Deployment (20 mins) - PRIMARY FOCUS**:
- Add `externalNativeBuild` to `android/app/build.gradle` 
- Point to `../../native/CMakeLists.txt`
- Configure CMake arguments for Android NDK  
- Test: `flutter build apk` should auto-build and bundle native libraries
- **Result**: Zero manual steps for Android builds

**Dependency Management (15 mins) - CLEAN REPO**:
- Replace checked-in ONNX Runtime with package manager approach
- **Android**: Use Maven dependency `com.microsoft.onnxruntime:onnxruntime-android:1.22.0`
- **macOS**: Use Homebrew `brew install onnxruntime` or download script
- Update CMakeLists.txt to find system-installed ONNX Runtime
- **Result**: Remove 27MB+ from repo, cleaner dependency management

**macOS Solution (10 mins) - KEEP SIMPLE**:
- Manual deployment acceptable for development only
- No production deployment planned (no Apple dev account)
- Document current process, focus energy on Android

### Phase 1a Completion (1 hour)  
1. **Download YOLOv8n.onnx**: Find working download URL or use Python/pip
2. **Re-enable ONNX Runtime**: Uncomment includes and linking in CMake
3. **Test ONNX Environment**: Verify `Ort::Env` initialization works
4. **Return success message**: `"ONNX Runtime loaded successfully. Image: 640x480"`

### Phase 1b: Camera Integration (2-3 hours)
- Add `camera` plugin to `pubspec.yaml`
- Implement camera preview widget
- Capture images as `Uint8List` 
- Pass image data to `detect_objects()` FFI function

## Architecture Notes

**Directory Structure**:
```
native/
├── third_party/onnxruntime-osx-x64-1.22.0/  # ONNX Runtime binaries
├── models/yolov8n.onnx                       # Model file (placeholder)
├── CMakeLists.txt                            # Build configuration
├── include/spotitml_native.h                 # FFI interface
└── src/spotitml_native.cpp                   # Implementation
```

**Key Files**:
- `lib/spotitml_ffi.dart` - Flutter FFI bindings
- `lib/ffi_test_widget.dart` - Test UI with button
- `native/CMakeLists.txt` - Build config with ONNX Runtime setup

## Development Environment

**Working Configuration**:
- macOS 13.7.8 (22H730) 
- Flutter 3.32.5 stable
- Xcode 15.2 (15C500b)
- ONNX Runtime 1.22.0 (osx-x64)
- CMake with C++17 standard

**Flutter Issues**:
- `/tmp` permission errors with `flutter run` (use `flutter build` + manual launch)
- Hot reload broken due to temp directory restrictions

## Memory Bank

**Lessons Learned**:
1. **Start simple**: Prove basic FFI works before adding ONNX Runtime complexity
2. **Clean builds essential**: `flutter clean` + CMake clean required when changing native code
3. **Manual deployment reliable**: Automated deployment needs dedicated fixing session
4. **ONNX Runtime naming**: Uses versioned `.dylib` names (`libonnxruntime.1.22.0.dylib`)
5. **Code signing required**: macOS won't load unsigned dylibs in app bundles

**Technical Decisions**:
- ONNX Runtime over TensorFlow Lite (smaller, better YOLO support)
- YOLOv8n over newer versions (proven stability, good documentation)  
- Manual deployment acceptable for POC (fix in dedicated phase)
- C++17 standard (required by ONNX Runtime)

## Next Session Commands

**Quick Start (if continuing Phase 1a completion)**:
```bash
cd /Users/sebi/projects/SpotItML

# 1. Re-enable ONNX Runtime in native code
# Edit native/src/spotitml_native.cpp - uncomment ONNX includes & implementation
# Edit native/CMakeLists.txt - uncomment target_link_libraries

# 2. Download proper YOLO model
curl -L -o native/models/yolov8n.onnx [WORKING_URL_TO_BE_FOUND]

# 3. Build and test
cd native/build && make
# Then run manual deployment commands above

# 4. Test should show: "ONNX Runtime loaded successfully. Image: 640x480"
```

**Estimated Time to Phase 1a Complete**: 1-2 hours (model download + ONNX integration)
**Estimated Time to Phase 1b Complete**: +3-4 hours (camera integration)
- primary focus in android platform, apple platform secondary (no app store plans)