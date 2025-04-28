#pragma once

#include <cstdint>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define FFI_EXPORT __declspec(dllexport)
#else
#define FFI_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

// Get system status and version information
// Returns a string in format "version:status_code:status_message"
FFI_EXPORT const char* spotitml_get_system_status();

// Initialize the detector with a given ONNX model path
FFI_EXPORT void* spotitml_init_detector(const char* model_path);

// Free detector resources
FFI_EXPORT void spotitml_free_detector(void* detector);

// Process image and return results
// Result format: "symbol1:conf1:x1:y1:x2:y2;symbol2:conf2:x1:y1:x2:y2;..."
FFI_EXPORT const char* spotitml_detect_symbols(void* detector,
                                  uint8_t* image_data,
                                  int width,
                                  int height,
                                  int channels);

// Set log callback function
typedef void (*log_callback_t)(int level, const char* message);
FFI_EXPORT void spotitml_set_log_callback(log_callback_t callback);

// Get last error message
FFI_EXPORT const char* spotitml_get_last_error();

// Simple test function that adds two numbers - will be replaced with ML inference later
FFI_EXPORT int32_t add_numbers(int32_t a, int32_t b);

// Initialize the ML system - currently just returns success
FFI_EXPORT bool initialize_ml();

FFI_EXPORT const char* get_version();

const char* get_version_string();

#ifdef __cplusplus
}
#endif