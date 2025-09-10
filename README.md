# SpotItML

Flutter app with C++ native ONNX Runtime integration for ML-powered object detection.

## Features

- 📱 **Cross-platform**: Android and macOS support
- 🧠 **ML Integration**: ONNX Runtime for object detection inference
- 🎯 **Native Performance**: C++ FFI with professional CMake integration
- 📷 **Camera Pipeline**: Real-time camera input with ML processing

## Getting Started

### Prerequisites
- Flutter SDK
- **macOS**: `brew install onnxruntime` 
- **Android**: NDK (handled automatically via Gradle)
- **yolov8n.onnx model**: `mkdir -p assets/models && curl -O assets/models/yolov8n.onnx https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n.onnx`

### Quick Start
```bash
flutter pub get
flutter run
```

---

## Development

### Build System Architecture

This project uses a **hybrid approach** for ONNX Runtime integration:
- **CMake**: Handles headers, compilation, and linking
- **Gradle**: Manages runtime library deployment (Android)
- **Professional**: Modern imported targets, no hardcoded paths

### Build Directories

The project creates several build directories during development:

#### **Flutter Build Directories:**
- `build/` - Main Flutter build artifacts and CMake cache
- `build/.cxx/` - CMake configuration and native compilation
- `build/app/` - Android app build outputs

#### **Platform-Specific:**
- `android/.gradle/` - Android project Gradle cache
- `android/build/` - Android module build outputs  
- `android/app/build/` - Android app module build outputs

### VSCode Development Tasks

Use **Ctrl+Shift+P** → **"Tasks: Run Task"** to access these build tasks:

#### **Build Tasks:**
- **"Flutter: Build Android Debug (Verbose)"** - Main build with full output
- **"Flutter: Build Android Release (Verbose)"** - Release build
- **"Flutter: Run Android Emulator (Verbose)"** - Run with detailed logs

#### **Clean Tasks:**
- **"Clean: Nuclear Project Clean"** 🚀 - Complete project clean (preserves HOME Gradle cache)
- **"CMake: Clean Cache Only"** - Just CMake cache (`build/.cxx/`)
- **"Gradle: Clean Android Build"** - Standard Gradle clean

#### **Debug Tasks:**
- **"Debug: Show CMake Output Log"** - Show CMake configuration logs

### Clean Build Process

For a **completely clean build**:

1. **VSCode**: `Ctrl+Shift+P` → **"Clean: Nuclear Project Clean"**
2. **Manual**: `rm -rf build android/.gradle android/build android/app/build`

**What gets preserved**: `~/.gradle/` cache (faster dependency downloads)

### Native C++ Development

The `native/` directory can be built as a **standalone CMake project**:

```bash
cd native/
mkdir build && cd build
cmake ..
make
```

**Current**: Builds `libspotitml_native.so` (shared library for FFI)  
**Future**: Standalone executable and unit tests (see project todos)

### ONNX Runtime Integration

- **Android**: Automatic AAR download via FetchContent
- **macOS**: System installation via Homebrew
- **Module**: `native/cmake/FindONNXRuntime.cmake` (reusable)
- **Targets**: `onnxruntime::headers`, `onnxruntime::onnxruntime`

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [ONNX Runtime](https://onnxruntime.ai/)
- [CMake Best Practices](https://cmake.org/cmake/help/latest/)
