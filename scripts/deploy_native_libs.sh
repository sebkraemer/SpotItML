#!/bin/bash
set -e

# Deploy Native Libraries Script
# Automatically copies and signs native libraries after Flutter build

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
NATIVE_BUILD_DIR="$PROJECT_ROOT/native/build"

echo "🔨 Building native libraries..."
cd "$NATIVE_BUILD_DIR" && make

echo "📦 Deploying to Flutter app bundles..."

# Deploy to both Debug and Release if they exist
for BUILD_TYPE in Debug Release; do
    FRAMEWORKS_DIR="$PROJECT_ROOT/build/macos/Build/Products/$BUILD_TYPE/spotitml.app/Contents/Frameworks"
    
    if [ -d "$(dirname "$FRAMEWORKS_DIR")" ]; then
        echo "  → Deploying to $BUILD_TYPE build"
        
        # Create Frameworks directory if needed
        mkdir -p "$FRAMEWORKS_DIR"
        
        # Copy our native library and ONNX Runtime (overwrite if exists)
        cp -f "$NATIVE_BUILD_DIR/libspotitml_native.dylib" "$FRAMEWORKS_DIR/"
        cp -f "$NATIVE_BUILD_DIR/libonnxruntime.1.22.2.dylib" "$FRAMEWORKS_DIR/"
        
        # Code sign all libraries
        codesign --force --sign - "$FRAMEWORKS_DIR/lib"*.dylib
        
        echo "  ✅ $BUILD_TYPE deployment complete"
    fi
done

echo "🎉 Native library deployment complete!"