# SpotitML Project Memory Bank

## Project Status Update (2025-07-08)

### Current Strategy Shift
**From:** Full Clean Architecture implementation with ONNX  
**To:** Minimal FFI bootstrap → Incremental feature addition

**Rationale:** Previous attempt was too complex upfront. New approach:
1. ✅ **Phase 1**: Basic Flutter + C++ FFI working (hello_world, add_numbers)
2. 🔄 **Phase 2**: Add camera preview + dummy detection
3. 🔄 **Phase 3**: Add existing YOLO model for MVP
4. 🔄 **Phase 4**: Custom Dobble training pipeline

### Key Learnings from Previous Attempt
1. **What Worked Well:**
   - Clean Architecture structure was solid
   - C++ ONNX integration approach was correct
   - FFI bridge design was appropriate
   - Test infrastructure was comprehensive

2. **What Was Overcomplicated:**
   - Full architecture implementation upfront
   - Complex dependency injection setup
   - Comprehensive testing before MVP
   - Too many moving parts simultaneously

3. **Reusable Assets:**
   - C++ ONNX integration code
   - Clean Architecture patterns (for later phases)
   - Test infrastructure design
   - FFI bridge interface design

### Current Implementation (2025-07-08)

#### Phase 1: Minimal FFI Bootstrap ✅
- Project name: `spotitml` (not dobble_detector)
- Basic Flutter app with FFI test interface
- C++ functions: `hello_world()`, `add_numbers()`
- Simple CMake build configuration
- Platform-specific library loading (Android/iOS/Desktop)

#### Architecture Decisions (Simplified)
1. **Start Minimal**: No clean architecture initially
2. **Prove FFI Works**: Simple test functions first
3. **Incremental Complexity**: Add one feature at a time
4. **Reuse Previous Work**: Leverage C++ ONNX code when ready

#### File Structure (Current)
```
spotitml/
├── lib/
│   └── main.dart                    # Simple FFI test UI
├── native/
│   ├── include/spotitml_native.h    # Basic C interface
│   ├── src/spotitml_native.cpp      # Test functions
│   └── CMakeLists.txt               # Build config
├── android/app/CMakeLists.txt       # Android native build
└── pubspec.yaml                     # Minimal dependencies
```

#### Dependencies (Minimal)
```yaml
dependencies:
  flutter:
    sdk: flutter
  ffi: ^2.1.0
  cupertino_icons: ^1.0.6
```

### Development Tools Strategy

#### VS Code + Copilot Integration
Using Copilot as primary code assistant with Memory Bank as context:

1. **Context Loading**: Use comments to reference Memory Bank
2. **Incremental Prompting**: Guide Copilot step-by-step
3. **Architecture Guidance**: Reference previous clean architecture when expanding

#### Copilot Instruction Method
Place this comment at the top of files to give Copilot context:
```dart
// CONTEXT: SpotitML project - symbol detection app using Flutter + C++ FFI + ML
// CURRENT PHASE: Basic FFI bootstrap (hello_world, add_numbers functions)
// NEXT PHASE: Add camera preview + dummy detection
// ARCHITECTURE: Starting minimal, will add Clean Architecture later
// REF: See memory-bank/spotitml-memory-bank.md for full context
```

### Next Immediate Steps

#### Phase 2: Add Camera (After FFI Bootstrap Works)
1. Add camera dependency: `camera: ^0.10.5+5`
2. Create simple camera preview screen
3. Add C++ function: `process_image_dummy()` 
4. Convert camera frames to bytes for C++
5. Return dummy detection results

#### Phase 3: MVP with Existing Model
1. Integrate YOLOv8 COCO model (existing)
2. Filter for Dobble-relevant symbols
3. Real detection pipeline working
4. Basic symbol matching logic

#### Phase 4: Clean Architecture Migration
1. Introduce domain layer from previous work
2. Add repository pattern
3. Implement proper error handling
4. Add comprehensive testing

#### Phase 5: Custom Dobble Training
1. Dataset creation and annotation
2. YOLOv8 custom training
3. ONNX export optimization
4. Production deployment

### Reusable Code Assets from Previous Attempt

#### C++ ONNX Integration (Save for Phase 3)
```cpp
// From previous attempt - proven working
class ONNXRunner {
    Ort::Session* session;
    Ort::MemoryInfo memory_info;
    // ... initialization and inference code
};
```

#### Clean Architecture Structure (Save for Phase 4)
```
lib/
├── core/                 # Utilities, constants
├── domain/              # Business logic, entities
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/                # Data layer implementations
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/        # UI layer
    ├── screens/
    ├── widgets/
    └── viewmodels/
```

#### FFI Bridge Interface (Adapt for Current Phase)
```cpp
// From previous - adapt incrementally
extern "C" {
    void* create_detector();
    int detect_symbols(void* detector, uint8_t* image_data, 
                      int width, int height, float* results);
    void destroy_detector(void* detector);
}
```

### Key Success Metrics

#### Phase 1 Success Criteria (Current) ✅
- [ ] Flutter app loads successfully
- [ ] Native library loads without errors
- [ ] `hello_world()` returns expected string
- [ ] `add_numbers(15, 27)` returns 42
- [ ] Works on target platforms (Android/iOS/Desktop)

#### Phase 2 Success Criteria (Next)
- [ ] Camera preview displays
- [ ] Camera frames convert to byte arrays
- [ ] C++ processes image data (dummy)
- [ ] UI shows "detected" dummy symbols

#### Phase 3 Success Criteria
- [ ] Real YOLO model loads
- [ ] Actual symbol detection working
- [ ] Basic Dobble matching logic
- [ ] MVP functionality complete

### Development Environment

#### Tools in Use
- **Primary IDE**: VS Code with Copilot extension
- **AI Assistant**: GitHub Copilot for code generation
- **Context Management**: This Memory Bank file
- **Build System**: CMake for C++, Flutter build for Dart

#### Copilot Prompt Patterns
1. **File Context**: Always include project context in file headers
2. **Incremental Requests**: Ask for one feature at a time
3. **Reference Patterns**: "Based on previous SpotitML architecture..."
4. **Error Debugging**: "FFI loading error in SpotitML project..."

### Architecture Evolution Plan

#### Current (Phase 1): Minimal
```
Flutter App → FFI → C++ Test Functions
```

#### Target (Phase 4): Clean Architecture
```
UI → ViewModel → UseCase → Repository → DataSource → FFI → C++ ONNX
```

#### Migration Strategy
- Keep current simple structure working
- Add layers incrementally
- Refactor only when adding complexity
- Test at each step

---

## How to Use This Memory Bank with Copilot

### 1. Reference in File Headers
Always start your files with context:
```dart
// SpotitML: Symbol detection app (Flutter + C++ FFI + ML)
// Phase: Basic FFI bootstrap - test functions working
// Next: Add camera preview and dummy detection
// Context: See memory-bank/spotitml-memory-bank.md
```

### 2. Copilot Chat Commands
Use **Ctrl+Shift+I** in VS Code:
- "Based on SpotitML memory bank, help me add camera preview"
- "Following SpotitML FFI patterns, create image processing function"
- "Adapt SpotitML architecture to add [new feature]"

### 3. Update After Major Changes
Add new sections to this file when:
- Phase completed successfully
- Major architecture decisions made
- New problems/solutions discovered
- Ready to move to next phase
