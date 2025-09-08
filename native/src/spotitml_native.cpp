#include "spotitml_native.h"
#include <string>
#include <iostream>

// ONNX Runtime includes
#include "onnxruntime_cxx_api.h"

extern "C" {

const char* hello_world() {
    static std::string msg = "Hello from C++!";
    return msg.c_str();
}

int add_numbers(int a, int b) {
    return a + b;
}

const char* detect_objects(const uint8_t* image_data, int width, int height) {
    static std::string result_msg;
    
    try {
        // Initialize ONNX Runtime environment with verbose logging for development
        Ort::Env env(ORT_LOGGING_LEVEL_VERBOSE, "YOLOv8");
        
        // Phase 1a: Just test that ONNX Runtime loads successfully
        // Don't actually load the model yet - just return success status
        
        result_msg = "ONNX Runtime loaded successfully. Image: " + 
                    std::to_string(width) + "x" + std::to_string(height);
        
        return result_msg.c_str();
        
    } catch (const std::exception& e) {
        result_msg = "ONNX Runtime error: " + std::string(e.what());
        return result_msg.c_str();
    }
}

} // extern "C"
