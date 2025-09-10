#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Phase 1b: Object detection with ONNX Runtime
// Takes image data (RGB bytes) and dimensions, returns detection results as JSON string
// The caller should not free the returned pointer.
const char* detect_objects(const uint8_t* image_data, int width, int height);

#ifdef __cplusplus
}
#endif

