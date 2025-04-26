#pragma once

#include <string>
#include <vector>
#include <memory>
#include <onnxruntime_cxx_api.h>

namespace spotitml {

class ONNXRunner {
public:
    explicit ONNXRunner(const std::string& model_path);
    ~ONNXRunner();

    // Prevent copying
    ONNXRunner(const ONNXRunner&) = delete;
    ONNXRunner& operator=(const ONNXRunner&) = delete;

    // Allow moving
    ONNXRunner(ONNXRunner&&) = default;
    ONNXRunner& operator=(ONNXRunner&&) = default;

    /**
     * Run inference on an image
     * @param image_data Raw image data in RGB format
     * @param width Image width
     * @param height Image height
     * @param channels Number of color channels (should be 3 for RGB)
     * @return Vector of detection results in format [class_id, confidence, x, y, width, height] * N
     * @throws std::runtime_error if inference fails
     * @throws std::invalid_argument if input parameters are invalid
     */
    std::vector<float> runInference(
        const std::vector<uint8_t>& image_data,
        int width,
        int height,
        int channels
    );

private:
    void validateInput(
        const std::vector<uint8_t>& image_data,
        int width,
        int height,
        int channels
    ) const;

    Ort::Env env;
    Ort::SessionOptions session_options;
    std::unique_ptr<Ort::Session> session;
};

} // namespace spotitml