# SpotItML Project Memory Bank

## Project Setup (2025-04-26)

### Initial Architecture Setup
- Created Flutter project with org name `com.sebkraemer.spotitml`
- Implemented clean architecture folder structure:
  - `/lib/core`: Core utilities and constants
  - `/lib/domain`: Business logic and interfaces
  - `/lib/data`: Data layer implementations
  - `/lib/presentation`: UI components
  - `/lib/di`: Dependency injection
- Set up C++ integration structure:
  - `/cpp/include`: Public C++ headers
  - `/cpp/src/ml`: ML model integration
  - `/cpp/src/utils`: Utility functions
  - `/cpp/tests`: C++ unit tests

### Implementation Progress (2025-04-26)
1. **Core C++ Implementation**
   - Implemented ONNX runtime wrapper
   - Created C-style FFI bridge interface
   - Set up logging infrastructure

2. **Data Layer Implementation**
   - Created NativeBridge for FFI communication
   - Implemented SymbolRecognitionRepositoryImpl
   - Set up error handling and type conversion

3. **Domain Layer Implementation**
   - Created Symbol entity
   - Defined failure classes for error handling
   - Implemented repository interface
   - Created DetectSymbolsUseCase

4. **Presentation Layer Implementation**
   - Implemented CameraScreen with camera preview and symbol detection
   - Created SymbolOverlay widget for visualization
   - Set up CameraScreenViewModel with proper state management
   - Added camera lifecycle management
   - Implemented dependency injection with ServiceLocator

5. **Dependencies Added**
   - camera: For device camera access
   - provider: For state management
   - path_provider: For file system access
   - permission_handler: For runtime permissions
   - dartz: For functional error handling
   - ffi: For native code integration

6. **Testing Infrastructure Implementation**
   - Created comprehensive C++ test suite for ONNXRunner
   - Implemented test utilities for image and model generation
   - Added widget tests for camera screen UI
   - Set up integration tests for FFI bridge
   - Added unit tests for repository and view model

### Key Decisions
1. Symbol detection output format: [class_id, confidence, x, y, width, height] * N
2. Error handling strategy: Using Either type from dartz for functional error handling
3. Memory management: RAII in C++, proper disposal in Dart
4. Symbol mapping: Hardcoded initially, will move to configuration/assets

### Key Architectural Features
1. Single Responsibility: Each component has a clear, focused purpose
2. Dependency Injection: ServiceLocator manages object creation and lifecycle
3. MVVM Pattern: ViewModel manages UI state and business logic
4. Custom Painting: SymbolOverlay for real-time visualization
5. Error Handling: Comprehensive error handling across layers

### Test Coverage Areas
1. **C++ Components**
   - ONNXRunner initialization and cleanup
   - Input validation and error handling
   - Image data processing
   - Memory management
   - Model loading and inference

2. **Flutter Components**
   - Widget tests for CameraScreen
   - ViewModel state management
   - Repository implementation
   - Error handling and user feedback
   - Camera lifecycle management

3. **Integration Tests**
   - FFI bridge communication
   - Native code initialization
   - Memory management across language boundary
   - Error propagation
   - Camera integration

### Testing Strategy
1. **Unit Testing**
   - C++: Using GoogleTest framework
   - Dart: Using flutter_test and mockito
   - Mocking external dependencies
   - Testing error cases and edge conditions

2. **Integration Testing**
   - FFI communication validation
   - End-to-end symbol detection pipeline
   - Camera integration testing
   - Resource cleanup verification

3. **Widget Testing**
   - UI component rendering
   - User interaction handling
   - State management verification
   - Error state display
   - Loading state handling

### Next Steps
1. Implement unit tests for:
   - SymbolRecognitionRepositoryImpl
   - CameraScreenViewModel
   - DetectSymbolsUseCase
2. Add integration tests for:
   - FFI bridge
   - Camera initialization
   - Symbol detection pipeline
3. Add C++ tests for:
   - ONNX model integration
   - Image processing
4. Create model deployment pipeline
5. Add model quantization support
6. Implement missing test cases:
   - Camera permission handling
   - Model loading from assets
   - Background thread management
   - Memory leak detection
7. Set up CI/CD pipeline with test automation
8. Add performance benchmarking tests
9. Implement code coverage reporting
10. Create test data generation tools

### Technical Decisions
1. Using Provider pattern for state management
2. Implementing FFI bindings for direct C++ integration
3. Using Conan for C++ dependency management
4. Following clean architecture principles for better maintainability and testing