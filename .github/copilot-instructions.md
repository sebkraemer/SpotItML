# GitHub Copilot Instructions for SpotItML

## Project Overview
SpotItML is a Flutter application with native C++ components that uses machine learning to recognize symbols on Spot It! (Dobble) cards through the device camera.

## Technology Stack
- **Frontend**: Flutter/Dart
- **ML Inference**: C++ with ONNX Runtime
- **Bridge**: Dart FFI (Foreign Function Interface)
- **ML Training**: (Placeholder for future implementation) Python with fast.ai or Hugging Face
- **Build System**: Flutter build system, CMake for C++, Gradle for Android integration
- **Testing**: Flutter test framework, GoogleTest for C++

## Project Structure

- should contain a reasonable separation of flutter, c++, glue code and python/machine learning folders
- use `com.sebkraemer.spotitml` as org name

## Architecture & Best Practices

### Clean Architecture
Follow the clean architecture principles with clear separation of concerns:

1. **Domain Layer**:
   - Entities: Core business objects (e.g., `Symbol`, `Card`)
   - Repository interfaces: Abstract data operations (e.g., `ISymbolRecognitionRepository`)
   - Use cases: Business logic (e.g., `RecognizeSymbolsUseCase`)

2. **Data Layer**:
   - Repository implementations (e.g., `ONNXSymbolRecognitionRepository`)
   - Data sources: Native code bridge, camera service
   - Models: Data transfer objects and mappers

3. **Presentation Layer**:
   - UI components: Main screen, camera widget, results display
   - View models / controllers: Handle UI logic and state management
   - State management: Use Provider pattern for this project

### Native Code Implementation

#### ONNX Integration
- Create a C++ wrapper class for ONNX Runtime:
  ```cpp
  class ONNXModelRunner {
  public:
    ONNXModelRunner(const std::string& modelPath);
    ~ONNXModelRunner();
    
    std::vector<float> runInference(const std::vector<uint8_t>& imageData, 
                                    int width, int height, int channels);
    
  private:
    Ort::Env env;
    Ort::Session session;
    // Additional members
  };

## Architecture
Follow clean architecture principles with:
1. **Domain Layer**:
   - Entities representing core business objects
   - Repository interfaces
   - Use cases implementing business logic

2. **Data Layer**:
   - Repository implementations
   - Data sources (native ML code, camera)

3. **Presentation Layer**:
   - UI components (screens, widgets)
   - View models / controllers

## Native Code Structure
- C++ code should be organized in a modular fashion
- Use a clear abstraction for the ONNX runtime
- Implement proper error handling and logging
- Ensure memory management follows RAII principles
- Create a clean FFI interface for Dart communication

## Code Style & Best Practices
- Follow Flutter/Dart style guide
- Use proper dependency injection
- Write testable code with clear interfaces
- Document public APIs
- Use meaningful variable and function names
- Keep functions small and focused
- Implement proper error handling at all levels

## Testing Approach
- Unit tests for both Dart and C++ components
- Integration tests for the FFI interface
- UI tests for Flutter components
- Mock dependencies for isolated testing

## C++/Flutter Integration
- Use FFI for direct C++ calls
- Implement proper memory management across the boundary
- Create a robust error handling mechanism
- Consider using Platform Channels as fallback for complex interactions

## ML Pipeline
- Structure for model training and conversion
- Support for model quantization
- Utilities for model evaluation

## Build System
- Configure CMake for cross-platform C++ builds
- Set up Gradle properly for Android native integration
- Ensure iOS build process handles C++ code correctly

When implementing any component, focus on maintainability, testability, and performance.

## Logger Implementation

Implement a flexible logger for C++ with different log levels:
cppclass Logger {
public:
  enum Level { DEBUG, INFO, WARNING, ERROR };
  
  static void setLogCallback(std::function<void(Level, const std::string&)> callback);
  static void log(Level level, const std::string& message);
  
private:
  static std::function<void(Level, const std::string&)> mCallback;
  static void defaultLog(Level level, const std::string& message);
};


## FFI Interface

Create a clean C-style API for FFI:
cppextern "C" {
  // Initialize the detector
  void* init_detector(const char* model_path);
  
  // Free detector resources
  void free_detector(void* detector);
  
  // Process image and return results
  const char* detect_symbols(void* detector, uint8_t* image_data, 
                            int width, int height, int channels);
  
  // Set log callback
  void set_log_callback(void (*callback)(int level, const char* message));
}


## Flutter Implementation

### FFI Bindings

Use package:ffi to create Dart bindings:
dart// Define FFI signatures
typedef InitDetectorNative = Pointer Function(Pointer<Utf8> modelPath);
typedef InitDetector = Pointer Function(Pointer<Utf8> modelPath);

// Load the dynamic library
final DynamicLibrary _lib = Platform.isAndroid
    ? DynamicLibrary.open("libspotitml.so")
    : DynamicLibrary.process();
    
// Create function bindings
final InitDetector _initDetector = _lib
    .lookupFunction<InitDetectorNative, InitDetector>('init_detector');


### Camera Integration

Use the camera package for Flutter
Implement a CameraService in the data layer:
dartclass CameraService {
  CameraController? controller;
  
  Future<void> initialize() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
  }
  
  Future<Uint8List> captureImage() async {
    final image = await controller!.takePicture();
    return await image.readAsBytes();
  }
  
  // Additional methods
}


### UI Implementation

Create a main screen with camera preview and results display
Implement a button to trigger image capture and symbol recognition
Display debug logs and recognition results

## Testing Strategy

### C++ Testing

Use GoogleTest for C++ unit tests:
cpp#include <gtest/gtest.h>
#include "detector.h"

TEST(DetectorTest, DetectsSymbolsCorrectly) {
  // Test implementation
}


### Dart Testing

Implement unit tests for use cases and repositories
Create mocks for native dependencies:
dartclass MockSymbolRecognitionRepository extends Mock 
    implements ISymbolRecognitionRepository {}

Test the FFI integration with integration tests

## C++ Dependency Management with Conan

Use Conan as the package manager for C++ dependencies:

- Set up a `conanfile.txt` or `conanfile.py` in the cpp directory
- Include ONNX Runtime and other dependencies (GoogleTest, etc.)
- Configure CMake to use packages from Conan
- Document the Conan setup process in the README

Example conanfile.txt:

```
[requires]
onnxruntime/1.21.1
gtest/1.16.0
[generators]
cmake_find_package
cmake_paths
```

Example CMake integration:

```cmake
include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
find_package(onnxruntime REQUIRED)
find_package(GTest REQUIRED)
```

## Build Configuration

### CMake Configuration

Create a CMakeLists.txt file:
cmakecmake_minimum_required(VERSION 3.10)
project(spotitml)

# Find ONNX Runtime
find_package(ONNXRuntime REQUIRED)

# Main library
add_library(spotitml SHARED
  src/detector.cpp
  src/logger.cpp
  src/onnx_runner.cpp
)

target_include_directories(spotitml PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${ONNXRuntime_INCLUDE_DIRS}
)

target_link_libraries(spotitml
  ${ONNXRuntime_LIBRARIES}
)

# Tests
option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
  add_subdirectory(tests)
endif()


### Gradle Integration

Configure in android/app/build.gradle:
gradleandroid {
  // Existing configuration
  
  externalNativeBuild {
    cmake {
      path "../../cpp/CMakeLists.txt"
      
      // ABI filters
      abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
    }
  }
}


## Development Workflow

Start with setting up the Flutter project with proper architecture
Implement the C++ core for ONNX integration
Create FFI bindings to connect Flutter and C++
Implement the camera integration
Add the UI for camera control and results display
Set up comprehensive testing

Code Style & Documentation

Follow Flutter/Dart style guide
Document public APIs with dartdoc comments
Use meaningful variable and function names
Keep functions small and focused (≤ 20 lines preferred)
Add comments for complex algorithms or business rules

SOLID Principles

Single Responsibility: Each class should have only one reason to change
Open/Closed: Software entities should be open for extension but closed for modification
Liskov Substitution: Derived classes must be substitutable for their base classes
Interface Segregation: Make fine-grained interfaces specific to clients
Dependency Inversion: Depend on abstractions, not concretions

Performance Considerations

Optimize image processing before sending to ONNX
Use quantized models for faster inference
Run intensive processing in background isolates
Cache results when appropriate

When implementing any component, focus on maintainability, testability, and performance.

## Project structure

```
/lib
  /core                 # Core utilities and constants
  /domain               # Domain layer
    /entities
    /failures
    /repositories       # Repository interfaces
    /usecases
  /data                 # Data layer
    /repositories       # Repository implementations
    /datasources
    /models
  /presentation         # Presentation layer
    /screens
    /widgets
    /viewmodels
  /di                   # Dependency injection

/cpp
  /include              # Public headers
  /src                  # Implementation
    /ml
    /utils
  /tests                # C++ tests

/test                   # Dart tests
  /unit
  /integration
  /widget

/android                # Android-specific code
  /app
    /src
      /main
        /jniLibs        # Compiled C++ libraries

/ios                    # iOS-specific code
  /Runner
  /Frameworks           # iOS libraries

/docs                   # Documentation
  /requirements.md
  /architecture.md
  /project-requirements.md

/.github
  /copilot-instructions.md
  /memory-bank.md
```
