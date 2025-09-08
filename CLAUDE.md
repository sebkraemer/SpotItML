# SpotItML Development Notes

## Current Status (Phase 1a - Infrastructure Complete, ONNX Blocked)

**What Works**: ✅ Comprehensive build infrastructure
- Basic Flutter + C++ FFI pipeline working (`hello_world`, `add_numbers`, `detect_objects`)
- Automated Android build integration via Gradle + CMake
- Professional macOS build scripts (`scripts/build_macos.sh`, `scripts/deploy_native_libs.sh`)
- Proper RPATH linking configuration for macOS App Sandbox compatibility
- Clean dependency management (removed 27MB checked-in binaries)

**Current Blocker**: ❌ ONNX Runtime dependency hell
- **Problem**: Homebrew ONNX Runtime has 80+ transitive dependencies
- **Issue**: All dependencies use absolute paths (`/usr/local/opt/onnx/lib/libonnx.dylib`, etc.)
- **Conflict**: macOS App Sandbox blocks access to system library paths
- **Scale**: Would need to bundle and fix RPATH for dozens of libraries (onnx, protobuf, abseil, re2, etc.)
- **Status**: Too complex for current approach - need static ONNX Runtime build instead

**Infrastructure Completed**:
- Android: Maven dependency + automated native builds
- macOS: System package manager + automated build pipeline  
- Code signing automation for both platforms
- Clean repo (no checked-in binaries)

## Build Commands (Automated)

**Android (Production Platform)**:
```bash
# Automated build - no manual steps required
flutter build apk
# Result: APK with native libraries auto-bundled via Maven + CMake
```

**macOS (Development Platform)**:
```bash
# Automated build script (replaces all manual steps)
./scripts/build_macos.sh                    # Debug build
./scripts/build_macos.sh --release          # Release build

# Result: Fully built app with libraries deployed and signed
# Launch: open "build/macos/Build/Products/Debug/spotitml.app"
```

**Manual Steps (Legacy - Now Automated)**:
<details>
<summary>Old manual deployment process (superseded by scripts)</summary>

```bash
# 1. Build native library
cd native/build && make

# 2. Build Flutter app  
flutter build macos

# 3. Deploy libraries (now automated in scripts/deploy_native_libs.sh)
./scripts/deploy_native_libs.sh

# 4. Launch app
open "build/macos/Build/Products/Debug/spotitml.app"
```
</details>

## Next Steps Priority

### ✅ Phase 1a-bis: Build System Complete
All infrastructure goals achieved:
- ✅ Android automated builds with Maven + CMake integration  
- ✅ Clean dependency management (no checked-in binaries)
- ✅ macOS automated build scripts with proper RPATH linking
- ✅ Code signing automation for both platforms

### 🚧 Phase 1a: ONNX Runtime Integration (BLOCKED)

**Current Blocker - Dependency Hell**:
The Homebrew ONNX Runtime approach is fundamentally flawed for macOS app distribution:

```bash
# ONNX Runtime dependencies (partial list):
otool -L /usr/local/opt/onnxruntime/lib/libonnxruntime.1.22.2.dylib
# /usr/local/opt/onnx/lib/libonnx.dylib
# /usr/local/opt/protobuf/lib/libprotobuf.3.25.5.dylib  
# /usr/local/opt/abseil/lib/libabsl_*.dylib (20+ libraries)
# /usr/local/opt/re2/lib/libre2.11.dylib
# ... 80+ total transitive dependencies
```

**Problem**: All dependencies use absolute system paths blocked by App Sandbox.

**Potential Solutions**:
1. **Static ONNX Runtime build** (RECOMMENDED)
   - Download pre-built static libraries from Microsoft releases
   - Single `.a` file with all dependencies included
   - No RPATH/dylib issues to solve

2. **Custom ONNX Runtime build** (COMPLEX)  
   - Build from source with `-DBUILD_SHARED_LIBS=OFF`
   - Requires significant build infrastructure

3. **Bundling approach** (ABANDONED)
   - Would require bundling 80+ Homebrew libraries
   - Each needs individual RPATH fixing
   - Maintenance nightmare

**Recommended Path**: Switch to static ONNX Runtime build for Phase 1a completion.

### Phase 1a Completion (2-3 hours)
**Prerequisite**: Resolve ONNX Runtime dependency issue first

**Option A - Static Build Approach** (RECOMMENDED):
1. Download static ONNX Runtime from Microsoft releases
2. Update CMakeLists.txt to link static libraries instead of dynamic
3. Download YOLOv8n.onnx model file  
4. Test ONNX Environment initialization works
5. Verify: `"ONNX Runtime loaded successfully. Image: 640x480"`

**Option B - Android-First Approach** (PRAGMATIC):
1. Focus on Android where ONNX Runtime works via Maven
2. Get Android builds fully working with ONNX integration
3. Keep macOS as basic development platform (no ONNX Runtime)
4. Defer macOS ONNX Runtime until later phase

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

**Production Platform (Android)**:
- Flutter 3.32.5+ stable
- Android Studio with NDK
- Java 11+
- ONNX Runtime via Maven (automatic)
- CMake with C++17 standard

**Development Platform (macOS)**:
- macOS 13.7.8+ (22H730) 
- Flutter 3.32.5 stable
- Xcode 15.2+ (15C500b)
- **Required**: `brew install onnxruntime` (1.22.0+)
- CMake with C++17 standard

**Flutter Issues (macOS only)**:
- `/tmp` permission errors with `flutter run` (use `flutter build` + manual launch)
- Hot reload broken due to temp directory restrictions

**Setup Instructions**:
```bash
# macOS development setup
brew install onnxruntime cmake
flutter doctor  # Verify Flutter installation

# Android production ready (no additional setup)
flutter pub get
flutter build apk  # Should work out of the box
```

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

## CI/CD Strategy

**Android Production Pipeline**: ✅
- Automated builds on push/PR via GitHub Actions
- Maven handles ONNX Runtime dependency automatically
- Full test suite + APK artifact generation
- Zero manual dependency management

**macOS Development Only**: ✅  
- Local development with `brew install onnxruntime`
- Manual deployment steps documented
- No CI planned (not a deployment target)
- Keeps complexity low for development iteration

**Rationale**: Focus CI/CD effort on production platform (Android), keep development platform (macOS) simple and manual.
- primary focus in android platform, apple platform secondary (no app store plans)