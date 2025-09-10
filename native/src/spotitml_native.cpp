#include "spotitml_native.h"
#include <string>
#include <iostream>

// ONNX Runtime includes (only if available)
#if HAS_ONNXRUNTIME
#include "onnxruntime_cxx_api.h"
#endif

extern "C" {


const char* detect_objects(const uint8_t* image_data, int width, int height) {
    static std::string result_msg;
    
    std::cout << "DEBUG C++: detect_objects called with " << width << "x" << height << std::endl;
    
#if HAS_ONNXRUNTIME
    try {
        std::cout << "DEBUG C++: Attempting to initialize ONNX Runtime..." << std::endl;
        
        // Initialize ONNX Runtime environment with verbose logging for development
        Ort::Env env(ORT_LOGGING_LEVEL_VERBOSE, "YOLOv8");
        
        std::cout << "DEBUG C++: ONNX Runtime environment created successfully!" << std::endl;
        
        // Phase 1a: Just test that ONNX Runtime loads successfully
        // Don't actually load the model yet - just return success status
        
        result_msg = "ONNX Runtime loaded successfully. Image: " + 
                    std::to_string(width) + "x" + std::to_string(height);
        
        std::cout << "DEBUG C++: Returning: " << result_msg << std::endl;
        return result_msg.c_str();
        
    } catch (const std::exception& e) {
        std::cout << "DEBUG C++: ONNX Runtime exception: " << e.what() << std::endl;
        result_msg = "ONNX Runtime error: " + std::string(e.what());
        return result_msg.c_str();
    }
#else
    // ONNX Runtime not available (Android fallback)
    std::cout << "DEBUG C++: ONNX Runtime not available on this platform" << std::endl;
    result_msg = "FFI working (no ONNX Runtime). Image: " + 
                std::to_string(width) + "x" + std::to_string(height);
    
    std::cout << "DEBUG C++: Returning: " << result_msg << std::endl;
    return result_msg.c_str();
#endif
}

} // extern "C"
