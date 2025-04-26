#pragma once

#include <cstdint>

#ifdef __cplusplus
extern "C" {
#endif

// Initialize the detector with a given ONNX model path
void* spotitml_init_detector(const char* model_path);

// Free detector resources
void spotitml_free_detector(void* detector);

// Process image and return results
// Result format: "symbol1:conf1:x1:y1:x2:y2;symbol2:conf2:x1:y1:x2:y2;..."
const char* spotitml_detect_symbols(void* detector,
                                  uint8_t* image_data,
                                  int width,
                                  int height,
                                  int channels);

// Set log callback function
typedef void (*log_callback_t)(int level, const char* message);
void spotitml_set_log_callback(log_callback_t callback);

// Get last error message
const char* spotitml_get_last_error();

#ifdef __cplusplus
}
#endif