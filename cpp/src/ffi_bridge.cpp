#include "ffi_bridge.h"
#include "ml/onnx_runner.h"
#include "utils/logger.h"
#include <string>
#include <sstream>
#include <memory>
#include <thread>

namespace {
    const char* VERSION = "0.1.0";
    thread_local std::string lastError;
    thread_local std::string lastStatus;
    
    // Helper to create status string
    std::string createStatusString(const char* version, bool initialized, const char* message) {
        std::stringstream ss;
        ss << version << ":" << (initialized ? "1" : "0") << ":" << message;
        return ss.str();
    }
}

extern "C" {

const char* spotitml_get_system_status() {
    try {
        // For now just return a basic status - we'll expand this later
        lastStatus = createStatusString(VERSION, true, "System ready");
        return lastStatus.c_str();
    } catch (const std::exception& e) {
        lastError = e.what();
        lastStatus = createStatusString(VERSION, false, lastError.c_str());
        return lastStatus.c_str();
    }
}

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
        lastError = e.what();
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
        lastError = "Invalid detector handle";
        return nullptr;
    }

    try {
        std::vector<uint8_t> data(image_data, image_data + width * height * channels);
        auto results = g_model_runner->runInference(data, width, height, channels);
        // TODO: Format results as string
        return "test:0.95:0.1:0.2:0.3:0.4"; // Placeholder
    } catch (const std::exception& e) {
        lastError = e.what();
        return nullptr;
    }
}

const char* spotitml_get_last_error() {
    return lastError.c_str();
}

void spotitml_free_memory(void* ptr) {
    free(ptr);
}

}