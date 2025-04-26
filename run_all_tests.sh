#!/bin/bash
set -e  # Exit on any error

echo "Running C++ tests..."
cd cpp && ./run_tests.sh
cd ..

echo "Running Flutter tests..."
cd spotitml

echo "Generating mocks..."
dart run build_runner build --delete-conflicting-outputs

echo "Running unit and widget tests..."
flutter test

echo "Running integration tests..."
flutter test integration_test/app_test.dart

echo "All tests completed successfully!"