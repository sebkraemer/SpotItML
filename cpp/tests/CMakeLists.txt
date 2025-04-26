enable_testing()

# Test executable
add_executable(spotitml_tests
    ml/onnx_runner_test.cpp
)

# Link against our library and GTest
target_link_libraries(spotitml_tests
    PRIVATE
    spotitml
    GTest::gtest
    GTest::gtest_main
)

# Add tests to CTest
include(GoogleTest)
gtest_discover_tests(spotitml_tests)