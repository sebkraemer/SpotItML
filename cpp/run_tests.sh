#!/bin/bash

# Create build directory if it doesn't exist
mkdir -p build && cd build

# Install dependencies with Conan
conan install .. --build=missing

# Configure CMake
cmake .. -DBUILD_TESTS=ON

# Build the project and tests
cmake --build .

# Run the tests
ctest --output-on-failure