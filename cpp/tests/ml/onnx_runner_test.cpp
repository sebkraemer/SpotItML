#include <gtest/gtest.h>
#include "ml/onnx_runner.h"
#include "../test_utils.h"
#include <vector>
#include <stdexcept>
#include <filesystem>

namespace fs = std::filesystem;

class ONNXRunnerTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Create temporary test model
        const auto temp_dir = fs::temp_directory_path();
        modelPath = (temp_dir / "test_model.onnx").string();
        spotitml::test::createDummyModel(modelPath);
    }

    void TearDown() override {
        // Clean up test model
        if (fs::exists(modelPath)) {
            fs::remove(modelPath);
        }
    }

    std::string modelPath;
};

TEST_F(ONNXRunnerTest, ThrowsOnInvalidModelPath) {
    EXPECT_THROW(
        spotitml::ONNXRunner runner("nonexistent_model.onnx"),
        std::runtime_error
    );
}

TEST_F(ONNXRunnerTest, ThrowsOnInvalidImageData) {
    EXPECT_THROW({
        spotitml::ONNXRunner runner(modelPath);
        std::vector<uint8_t> emptyData;
        runner.runInference(emptyData, 0, 0, 3);
    }, std::invalid_argument);
}

TEST_F(ONNXRunnerTest, ThrowsOnInvalidDimensions) {
    std::vector<std::tuple<int, int, int>> invalidDims = {
        {-1, 10, 3},  // Invalid width
        {10, -1, 3},  // Invalid height
        {10, 10, 0},  // Invalid channels
        {0, 10, 3},   // Zero width
        {10, 0, 3},   // Zero height
        {10, 10, 4},  // Unsupported channels
    };

    for (const auto& [width, height, channels] : invalidDims) {
        EXPECT_THROW({
            spotitml::ONNXRunner runner(modelPath);
            auto imageData = spotitml::test::createTestImage(
                std::max(1, width),
                std::max(1, height),
                std::max(1, channels)
            );
            runner.runInference(imageData, width, height, channels);
        }, std::invalid_argument) << "Failed with dimensions: "
                                << width << "x" << height
                                << "x" << channels;
    }
}

TEST_F(ONNXRunnerTest, HandlesValidTestImage) {
    // This will throw due to dummy model, but we can verify the input handling
    const int width = 224;
    const int height = 224;
    const int channels = 3;

    auto testImage = spotitml::test::createTestImage(
        width, height, channels, 255, 0, 0  // Red test image
    );

    EXPECT_THROW({
        spotitml::ONNXRunner runner(modelPath);
        runner.runInference(testImage, width, height, channels);
    }, std::runtime_error);  // Should throw due to invalid model format
}

TEST_F(ONNXRunnerTest, ValidatesImageDataSize) {
    const int width = 224;
    const int height = 224;
    const int channels = 3;
    
    // Create image data with wrong size
    auto testImage = spotitml::test::createTestImage(
        width, height - 1, channels  // Wrong size
    );

    EXPECT_THROW({
        spotitml::ONNXRunner runner(modelPath);
        runner.runInference(testImage, width, height, channels);
    }, std::invalid_argument);
}