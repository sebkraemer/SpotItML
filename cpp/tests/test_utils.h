#pragma once

#include <vector>
#include <cstdint>
#include <string>
#include <fstream>
#include <stdexcept>

namespace spotitml {
namespace test {

// Creates a simple test image with a given size and color
inline std::vector<uint8_t> createTestImage(
    int width,
    int height,
    int channels,
    uint8_t r = 0,
    uint8_t g = 0,
    uint8_t b = 0
) {
    if (width <= 0 || height <= 0 || channels <= 0) {
        throw std::invalid_argument("Invalid image dimensions");
    }

    std::vector<uint8_t> image_data(width * height * channels);
    for (int i = 0; i < height; ++i) {
        for (int j = 0; j < width; ++j) {
            int pixel_idx = (i * width + j) * channels;
            if (channels >= 1) image_data[pixel_idx] = r;
            if (channels >= 2) image_data[pixel_idx + 1] = g;
            if (channels >= 3) image_data[pixel_idx + 2] = b;
        }
    }
    return image_data;
}

// Creates a dummy ONNX model file for testing
// Note: This is a placeholder that creates an invalid model file
// TODO: Replace with actual test model creation
inline std::string createDummyModel(const std::string& path) {
    std::ofstream model_file(path, std::ios::binary);
    if (!model_file) {
        throw std::runtime_error("Failed to create dummy model file");
    }

    // Write some dummy bytes
    const char dummy_data[] = "DUMMY_ONNX_MODEL";
    model_file.write(dummy_data, sizeof(dummy_data));
    model_file.close();

    return path;
}

} // namespace test
} // namespace spotitml