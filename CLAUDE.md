# SpotItML Development Notes

## Current Status (Phase 1a - COMPLETE! 🎉)

**✅ PHASE 1a ACHIEVED**: Flutter + C++ FFI + ONNX Runtime integration working end-to-end!

**What Works**: ✅ Full working pipeline
- Basic Flutter + C++ FFI pipeline: `hello_world` → "Hello from C++!", `add_numbers(3,4)` → 7  
- **ONNX Runtime integration**: `detect_objects` → "ONNX Runtime loaded successfully. Image: 640x480"
- Automated Android build integration via Gradle + CMake
- Professional macOS build scripts (`scripts/build_macos.sh`, `scripts/deploy_native_libs.sh`)
- Clean dependency management (removed 27MB checked-in binaries)

**Key Solution**: ❌ App Sandbox → ✅ Development Mode
- **Problem Solved**: Disabled App Sandbox for development builds (`com.apple.security.app-sandbox = false`)
- **Result**: Direct access to system ONNX Runtime libraries without bundling complexity
- **Trade-off**: No App Store distribution (which we don't need)

**Infrastructure Completed**:
- ✅ Android: Maven dependency + automated native builds
- ✅ macOS: System package manager + automated build pipeline + disabled sandbox
- ✅ Code signing automation for both platforms  
- ✅ Clean repo (no checked-in binaries)
- ✅ **ONNX Runtime working on macOS development platform**

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

### ✅ Phase 1a: COMPLETE!

**Achievement Summary**:
- ✅ Flutter + C++ FFI pipeline working
- ✅ ONNX Runtime integration successful (`Ort::Env` initialization working)
- ✅ Automated build system (Android + macOS)
- ✅ Clean dependency management
- ✅ Debug output confirmed: "ONNX Runtime loaded successfully. Image: 640x480"

**Final Solution - Disabled App Sandbox**:
- Modified `/macos/Runner/DebugProfile.entitlements`: `com.apple.security.app-sandbox = false`
- Direct system library access without bundling complexity
- Perfect for development (no App Store distribution needed)

**Debug Output Proof** (2025-09-09):
```
DEBUG C++: detect_objects called with 640x480
DEBUG C++: Attempting to initialize ONNX Runtime...
DEBUG C++: ONNX Runtime environment created successfully!
DEBUG C++: Returning: ONNX Runtime loaded successfully. Image: 640x480
flutter: DEBUG: detect_objects returned: ONNX Runtime loaded successfully. Image: 640x480
```

### 🚧 Phase 1b: Camera Integration (NEXT - 2-3 hours)

**Goal**: Replace test button with live camera feed + detection

**Implementation Plan**:
1. **Add camera plugin**: Add `camera: ^0.10.6` to `pubspec.yaml`
2. **Camera preview UI**: Replace `FfiTestWidget` with camera preview
3. **Capture integration**: Camera → `Uint8List` → `detect_objects()` FFI  
4. **Simplified FFI**: Remove `hello_world`/`add_numbers`, keep only `detect_objects`
5. **UI Design**: Camera preview + "Detect" button → show results overlay

**Expected Flow**:
- User sees live camera preview
- Clicks "Detect Objects" button  
- App captures current frame → passes to ONNX Runtime
- Results displayed as overlay on camera view

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

## Flutter Development Guidelines

### Code Quality & Structure
- **Separation of concerns**: Keep UI logic separate from business logic
- **Meaningful naming**: Use consistent, descriptive naming conventions
- **Widget composition**: Prefer composing smaller widgets over extending existing ones
- **Small widgets**: Use small, private `Widget` classes instead of helper methods that return widgets
- **Const optimization**: Use `const` constructors whenever possible for performance
- **Avoid expensive build operations**: No network calls or complex computations in `build()` methods

### State Management (Built-in Solutions Preferred)
- **Default approach**: Use Flutter's built-in state management unless explicitly requested otherwise
- **Single values**: `ValueNotifier` + `ValueListenableBuilder` for simple local state
- **Complex state**: `ChangeNotifier` + `ListenableBuilder` for shared or complex state  
- **Async operations**: `Future` + `FutureBuilder` for single async operations
- **Async streams**: `Stream` + `StreamBuilder` for sequence of async events
- **Dependency injection**: Manual constructor injection or `provider` package when needed

### Architecture Patterns
- **MVVM pattern**: Use Model-View-ViewModel pattern for robust applications
- **Repository pattern**: Abstract data sources (APIs, databases) using repositories/services
- **Data structures**: Define clear data classes to represent application data

### Navigation
- **Complex navigation**: Use `go_router` for declarative navigation, deep linking, web support
- **Simple navigation**: Use built-in `Navigator` for dialogs and temporary views

### Error Handling & Logging
- **Structured logging**: Use `dart:developer` log function instead of `print`
- **Error handling**: Implement graceful error handling with try-catch, Either types, or global handlers
- **DevTools integration**: Use `developer.log` with named categories and error objects

### Data Handling
- **JSON serialization**: Use `json_serializable` + `json_annotation` for JSON parsing
- **Field naming**: Use `fieldRename: FieldRename.snake` to convert camelCase to snake_case
- **Code generation**: Use `build_runner` for all code generation tasks

### Performance & Best Practices
- **ListView optimization**: Use `ListView.builder` for lazy-loaded lists
- **Async/await**: Proper use of async/await with robust error handling  
- **Pattern matching**: Use pattern matching features where they simplify code
- **Documentation**: Add documentation comments to all public APIs

### UI & Theming
- **Material 3**: Use `useMaterial3: true` in ThemeData
- **Theme consistency**: Define centralized ThemeData for consistent styling
- **Color schemes**: Use `ColorScheme.fromSeed` for harmonious color palettes
- **Dark/light themes**: Support both themes with user toggle capability
- **Custom fonts**: Use `google_fonts` package with defined TextTheme
- **Accessibility**: Implement A11Y features for diverse user needs

### Asset Management
- **Image handling**: Use `Image.asset` for local assets, `Image.network` with loading/error builders
- **Asset declaration**: Declare all asset paths in `pubspec.yaml`
- **Responsive design**: Ensure mobile responsiveness across different screen sizes

### Testing
- **Unit tests**: Use `package:test` for unit tests
- **Widget tests**: Use `package:flutter_test` for widget tests  
- **Integration tests**: Use `package:integration_test` for end-to-end tests
- **Assertions**: Prefer `package:checks` for expressive assertions over default matchers

### Package Management
- **Dependency selection**: Choose stable, well-maintained packages from pub.dev
- **Add dependencies**: Use `flutter pub add <package>` for regular deps
- **Dev dependencies**: Use `flutter pub add dev:<package>` for development deps

### AI Assistant Guidelines (MCP Integration)
- **Proactive diagnostics**: Use MCP `getDiagnostics` tool automatically to check for errors, warnings, and issues
- **Real-time monitoring**: Leverage VS Code's Language Server Protocol integration via MCP for live error detection
- **Error prevention**: Run diagnostics before and after code changes to catch issues early
- **Cross-platform awareness**: Monitor both Dart/Flutter and native C++ code diagnostics simultaneously
- **No configuration needed**: MCP integration works automatically through Claude Code extension in VS Code