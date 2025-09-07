#include "spotitml_native.h"
#include <string>
#include <iostream>

// ONNX Runtime includes (temporarily disabled for basic FFI test)
// #include "onnxruntime_cxx_api.h"

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
    
    // Phase 1a: Start with basic functionality, add ONNX Runtime later
    result_msg = "Basic FFI working. Image: " + 
                std::to_string(width) + "x" + std::to_string(height);
    
    // TODO: Add ONNX Runtime initialization once basic FFI is verified
    /*
    try {
        Ort::Env env(ORT_LOGGING_LEVEL_VERBOSE, "YOLOv8");
        result_msg += " + ONNX Runtime loaded successfully";
        return result_msg.c_str();
    } catch (const std::exception& e) {
        result_msg += " + ONNX Runtime error: " + std::string(e.what());
        return result_msg.c_str();
    }
    */
    
    return result_msg.c_str();
}

} // extern "C"
