#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Returns a pointer to a null-terminated hello world string.
// The caller should not free the returned pointer.
const char* hello_world(void);

// Adds two integers and returns the result.
int add_numbers(int a, int b);

// ONNX Runtime inference function (Phase 1a: dummy return)
// Returns a status message about ONNX Runtime loading
const char* detect_objects(const uint8_t* image_data, int width, int height);

#ifdef __cplusplus
}
#endif

