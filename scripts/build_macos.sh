#!/bin/bash
set -e

# SpotitML macOS Build Script
# Builds Flutter app with native library integration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🍎 SpotitML macOS Build Pipeline"
echo "================================"

# Default to debug build
BUILD_MODE="debug"
if [[ "$1" == "--release" ]]; then
    BUILD_MODE="release"
    echo "📦 Building RELEASE version"
else
    echo "🐛 Building DEBUG version"
fi

echo ""
echo "Step 1: Building native libraries..."
cd "$PROJECT_ROOT/native/build"
make
echo "✅ Native libraries built"

echo ""
echo "Step 2: Building Flutter app..."
cd "$PROJECT_ROOT"
if [[ "$BUILD_MODE" == "release" ]]; then
    flutter build macos --release
else
    flutter build macos --debug
fi
echo "✅ Flutter app built"

echo ""
echo "Step 3: Deploying native libraries..."
"$PROJECT_ROOT/scripts/deploy_native_libs.sh"
echo "✅ Native libraries deployed"

echo ""
echo "🎉 Build complete!"
if [[ "$BUILD_MODE" == "release" ]]; then
    APP_PATH="$PROJECT_ROOT/build/macos/Build/Products/Release/spotitml.app"
else  
    APP_PATH="$PROJECT_ROOT/build/macos/Build/Products/Debug/spotitml.app"
fi

echo "📱 App ready at: $APP_PATH"
echo ""
echo "To run: open \"$APP_PATH\""