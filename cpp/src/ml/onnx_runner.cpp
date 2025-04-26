#include "ml/onnx_runner.h"
#include "utils/logger.h"
#include <memory>
#include <vector>
#include <stdexcept>

namespace spotitml {

ONNXRunner::ONNXRunner(const std::string& model_path) 
    : env(ORT_LOGGING_LEVEL_WARNING, "SpotItML"),
      allocator() {
    
    Logger::log(Logger::Level::INFO, "Initializing ONNX Runtime with model: " + model_path);
    
    Ort::SessionOptions session_options;
    session_options.SetIntraOpNumThreads(1);
    session_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_ALL);
    
    try {
        session = std::make_unique<Ort::Session>(env, model_path.c_str(), session_options);
        Logger::log(Logger::Level::INFO, "ONNX Runtime initialized successfully");
    } catch (const Ort::Exception& e) {
        Logger::log(Logger::Level::ERROR, "Failed to initialize ONNX Runtime: " + std::string(e.what()));
        throw;
    }
}

ONNXRunner::~ONNXRunner() {
    Logger::log(Logger::Level::DEBUG, "Cleaning up ONNX Runner");
}

std::vector<float> ONNXRunner::runInference(const std::vector<uint8_t>& image_data,
                                          int width, int height, int channels) {
    try {
        // Convert uint8 image data to float and normalize
        std::vector<float> input_tensor_values(image_data.size());
        for (size_t i = 0; i < image_data.size(); i++) {
            input_tensor_values[i] = image_data[i] / 255.0f;
        }

        // Define input shape
        std::vector<int64_t> input_shape = {1, channels, height, width};
        
        // Create input tensor
        auto memory_info = Ort::MemoryInfo::CreateCpu(OrtArenaAllocator, OrtMemTypeDefault);
        Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
            memory_info,
            input_tensor_values.data(),
            input_tensor_values.size(),
            input_shape.data(),
            input_shape.size()
        );

        // Define input/output names
        Ort::AllocatorWithDefaultOptions allocator;
        auto input_name = session->GetInputNameAllocated(0, allocator);
        auto output_name = session->GetOutputNameAllocated(0, allocator);

        // Run inference
        auto output_tensors = session->Run(
            Ort::RunOptions{nullptr},
            &input_name,
            &input_tensor,
            1,
            &output_name,
            1
        );

        // Get output data
        float* output_data = output_tensors[0].GetTensorMutableData<float>();
        size_t output_size = output_tensors[0].GetTensorTypeAndShapeInfo().GetElementCount();
        
        return std::vector<float>(output_data, output_data + output_size);
        
    } catch (const Ort::Exception& e) {
        Logger::log(Logger::Level::ERROR, "Inference failed: " + std::string(e.what()));
        throw;
    }
}