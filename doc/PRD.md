# SpotitML - Product Requirements Document

*This PRD serves as the living specification for SpotitML development and will be updated as requirements evolve.*

## 1. Product Vision

**Mission**: Create a mobile app that uses computer vision to enhance the Dobble card game experience by automatically detecting symbols and finding matches between cards.

**Target Users**: 
- Dobble players (families, children 6+, casual gamers)
- People with visual difficulties who struggle to spot matches quickly
- Competitive players wanting to verify matches

## 2. Core User Journey

### Primary Use Case: "Find the Match"
1. **Setup**: User places two Dobble cards on table
2. **Capture**: User points phone camera at both cards  
3. **Detection**: App identifies all symbols on both cards
4. **Match**: App highlights the common symbol between cards
5. **Verification**: User confirms the match is correct

### Secondary Use Case: "Practice Mode"
1. User shows single card to camera
2. App lists all detected symbols on that card
3. User can verify accuracy of detection

## 3. Functional Requirements

### 3.1 Core Features (MVP)

#### F1: Camera Integration
- **REQ-F1.1**: App shall provide live camera preview
- **REQ-F1.2**: User can capture photos of Dobble cards
- **REQ-F1.3**: App shall handle various lighting conditions
- **REQ-F1.4**: Camera shall support both landscape and portrait orientations

#### F2: Symbol Detection  
- **REQ-F2.1**: App shall detect at least 50 of 55 Dobble symbols
- **REQ-F2.2**: Detection accuracy shall be >90% under good lighting
- **REQ-F2.3**: App shall process one card in <2 seconds
- **REQ-F2.4**: App shall handle cards at various angles (±15°)

#### F3: Match Finding
- **REQ-F3.1**: App shall identify the common symbol between two cards
- **REQ-F3.2**: Match result shall be displayed within 3 seconds
- **REQ-F3.3**: App shall highlight the matching symbol on both cards
- **REQ-F3.4**: App shall handle cases where no match is detected

#### F4: User Interface
- **REQ-F4.1**: Simple, intuitive interface suitable for children 6+
- **REQ-F4.2**: Clear visual feedback during processing
- **REQ-F4.3**: Results displayed with large, readable text
- **REQ-F4.4**: Option to retake photo if detection fails

### 3.2 Enhanced Features (Future)

#### F5: Game Enhancement
- **REQ-F5.1**: Score tracking for competitive play
- **REQ-F5.2**: Timer for speed challenges  
- **REQ-F5.3**: Statistics on detection accuracy
- **REQ-F5.4**: Tutorial mode for new players

#### F6: Accessibility
- **REQ-F6.1**: Voice announcements of detected symbols
- **REQ-F6.2**: High contrast mode for visual impairments
- **REQ-F6.3**: Large text options
- **REQ-F6.4**: Haptic feedback for confirmations

## 4. Technical Requirements

### 4.1 Performance
- **REQ-T1.1**: Symbol detection latency <2 seconds on mid-range devices
- **REQ-T1.2**: App startup time <3 seconds
- **REQ-T1.3**: Memory usage <200MB during operation
- **REQ-T1.4**: Battery usage optimized for 30+ minute sessions

### 4.2 Platform Support (Updated for POC)
- **REQ-T2.1**: Android API 21+ support (Primary target)
- **REQ-T2.2**: iOS Simulator support (Intel Mac development)
- **REQ-T2.3**: macOS desktop support (Development/debugging)
- **REQ-T2.4**: Camera resolution minimum 8MP (Android focus)

### 4.3 Architecture
- **REQ-T3.1**: Flutter framework for cross-platform UI
- **REQ-T3.2**: C++ native library for ML inference
- **REQ-T3.3**: ONNX Runtime for model execution
- **REQ-T3.4**: YOLOv8-based object detection model

### 4.4 Offline Capability
- **REQ-T4.1**: All processing performed on-device
- **REQ-T4.2**: No internet connection required for core functionality
- **REQ-T4.3**: Model embedded in app bundle

## 5. Success Metrics

### 5.1 Technical Metrics
- **Symbol Detection Accuracy**: >90% in good lighting
- **False Positive Rate**: <5% 
- **Processing Speed**: <2 seconds per card
- **Crash Rate**: <1% of sessions

### 5.2 User Experience Metrics  
- **User Satisfaction**: >4.0/5.0 app store rating
- **Session Duration**: Average 15+ minutes
- **Retention**: 70% return after first week
- **Tutorial Completion**: 80% complete onboarding

## 6. User Stories

### Epic 1: Basic Detection
- **US-1.1**: As a player, I want to point my camera at a Dobble card so that I can see which symbols are detected
- **US-1.2**: As a player, I want to see the confidence level of each detection so that I can trust the results
- **US-1.3**: As a player, I want clear visual indicators of detected symbols so that I can verify accuracy

### Epic 2: Match Finding  
- **US-2.1**: As a player, I want to show two cards to the camera so that the app finds the matching symbol
- **US-2.2**: As a competitive player, I want fast match detection so that I can verify quick plays
- **US-2.3**: As a parent, I want the app to help my child learn the game by showing matches clearly

### Epic 3: Accessibility
- **US-3.1**: As a visually impaired player, I want voice announcements so that I can play without seeing the screen clearly
- **US-3.2**: As an elderly player, I want large text options so that I can read the results easily

## 7. Non-Functional Requirements

### 7.1 Usability
- App shall be usable by children age 6+ without assistance
- Learning curve shall be <5 minutes for basic functionality
- UI shall follow platform design guidelines (Material Design/Human Interface)

### 7.2 Reliability
- App shall not crash during normal operation
- Detection accuracy shall be consistent across different devices
- App shall gracefully handle edge cases (poor lighting, tilted cards, etc.)

### 7.3 Privacy
- No user data collection beyond basic analytics
- All image processing performed locally
- No images stored or transmitted

## 8. Technical Constraints

### 8.1 Model Constraints
- Model size <50MB for app store optimization
- Inference time <2 seconds on target hardware
- Support for ARM64 and x86_64 architectures

### 8.2 Development Constraints  
- Use existing YOLO architecture for faster development
- Leverage transfer learning to minimize training data requirements
- FFI bridge for Flutter-C++ integration

## 9. Acceptance Criteria

### Phase 1: MVP Ready
- [ ] Camera preview functional on iOS and Android
- [ ] Basic symbol detection working (>70% accuracy)
- [ ] Two-card match finding functional
- [ ] UI intuitive for target age group

### Phase 2: Production Ready
- [ ] Symbol detection >90% accurate
- [ ] Processing time <2 seconds consistently  
- [ ] Comprehensive error handling
- [ ] App store submission ready

### Phase 3: Enhanced
- [ ] Advanced features (scoring, timer, etc.)
- [ ] Accessibility features implemented
- [ ] Performance optimized for low-end devices

## 10. Implementation Phases

### Phase 1a: ONNX Runtime Integration (1-2 hours) - 🔄 PARTIALLY COMPLETED
- ✅ Flutter + C++ FFI pipeline established
- ✅ Add ONNX Runtime to CMake build (configured but temporarily disabled)
- ❌ Download YOLOv8n.onnx model (6MB) - failed downloads, placeholder exists
- ✅ Create basic C++ inference function (dummy return without ONNX)
- ✅ Test FFI call works: `detect_objects(dummy_data) → "Basic FFI working. Image: 640x480"`

**Missing for Phase 1a completion**:
- ❌ Actually integrate ONNX Runtime (currently commented out due to library deployment issues)
- ❌ Download working YOLOv8n.onnx model
- ❌ Test ONNX Runtime environment initialization
- ❌ Fix automated library deployment (manual copy required currently)

### Phase 1b: Camera + Image Processing (2-3 hours)  
- 🔄 Add camera preview to Flutter
- 🔄 Capture image as byte array
- 🔄 Send image data to C++ via FFI
- 🔄 C++ receives image, returns size/dimensions
- 🔄 Display "Processed 640x480 image" in Flutter

### Phase 1c: Real YOLO Detection (2-4 hours)
- 🔄 Implement actual YOLOv8 inference in C++
- 🔄 Return raw detection count: "Found 23 objects"
- 🔄 Filter for COCO classes: person(0), bird(16), cat(17), dog(18)
- 🔄 Return filtered results to Flutter
- 🔄 Display: "Dobble symbols found: cat, dog"

### Phase 1d: Basic Debug Toggle (1 hour)
- 🔄 Add debug switch in Flutter UI
- 🔄 Show detection confidence scores when enabled
- 🔄 Display inference timing: "Detection took 156ms"

### Phase 2a: Visual Debug Overlay (3-4 hours)
- 📋 Draw bounding boxes on camera preview
- 📋 Show confidence scores as floating text
- 📋 Add FPS counter

### Phase 1a-bis: Build System Improvements (45 minutes)  
- 📋 **Android Deployment**: Add Gradle + CMake integration to `android/app/build.gradle`
- 📋 Configure `externalNativeBuild` pointing to native/CMakeLists.txt  
- 📋 **Dependency Management**: Replace checked-in ONNX Runtime (27MB+) with package managers
- 📋 **Android**: Use Maven `com.microsoft.onnxruntime:onnxruntime-android:1.22.0`
- 📋 **macOS**: Use Homebrew `brew install onnxruntime` or download script
- 📋 Test `flutter build apk` auto-builds and bundles native libraries
- 📋 **macOS**: Keep manual deployment (development only, no App Store plans)

### Phase 2b: Two-Card Logic (2-3 hours)  
- 📋 Detect multiple cards in single image
- 📋 Find common symbols between detected regions
- 📋 Highlight matching symbol

### Phase 3a: Custom Dataset Creation (1-2 weeks)
- 📋 Photograph Dobble cards systematically  
- 📋 Annotation with LabelImg/Roboflow
- 📋 Create YOLO dataset format

### Phase 3b: Custom Model Training (3-5 days)
- 📋 YOLOv8 fine-tuning on Dobble dataset
- 📋 Model validation and optimization
- 📋 ONNX export for production

---
