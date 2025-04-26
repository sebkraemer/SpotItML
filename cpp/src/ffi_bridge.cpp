#include "ffi_bridge.h"
#include "ml/onnx_runner.h"
#include "utils/logger.h"
#include <string>
#include <memory>
#include <cstring>

using namespace spotitml;

namespace {
    std::unique_ptr<ONNXModelRunner> g_model_runner;
    std::string g_last_error;
    log_callback_t g_log_callback = nullptr;

    void setError(SpotItmlError* error, const char* message, int code = -1) {
        if (error) {
            error->message = strdup(message);
            error->code = code;
        }
    }

    void clearError(SpotItmlError* error) {
        if (error) {
            error->message = nullptr;
            error->code = 0;
        }
    }
}

extern "C" {

void spotitml_set_log_callback(log_callback_t callback) {
    g_log_callback = callback;
    Logger::setLogCallback([](Logger::Level level, const std::string& message) {
        if (g_log_callback) {
            g_log_callback(static_cast<int>(level), message.c_str());
        }
    });
}

void* spotitml_init_detector(const char* model_path) {
    try {
        g_model_runner = std::make_unique<ONNXModelRunner>(model_path);
        return g_model_runner.get();
    } catch (const std::exception& e) {
        g_last_error = e.what();
        return nullptr;
    }
}

void spotitml_free_detector(void* detector) {
    if (detector == g_model_runner.get()) {
        g_model_runner.reset();
    }
}

const char* spotitml_detect_symbols(void* detector, 
                                  uint8_t* image_data,
                                  int width, 
                                  int height, 
                                  int channels) {
    if (!detector || detector != g_model_runner.get()) {
        g_last_error = "Invalid detector handle";
        return nullptr;
    }

    try {
        std::vector<uint8_t> data(image_data, image_data + width * height * channels);
        auto results = g_model_runner->runInference(data, width, height, channels);
        // TODO: Format results as string
        return "test:0.95:0.1:0.2:0.3:0.4"; // Placeholder
    } catch (const std::exception& e) {
        g_last_error = e.what();
        return nullptr;
    }
}

const char* spotitml_get_last_error() {
    return g_last_error.c_str();
}

void spotitml_free_memory(void* ptr) {
    free(ptr);
}

}