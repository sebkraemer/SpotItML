import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// Bindings for the native C++ library
class SpotitmlNative {
  static final ffi.DynamicLibrary _lib = _open();

  static ffi.DynamicLibrary _open() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libspotitml_native.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('libspotitml_native.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('spotitml_native.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Phase 1b: Simplified to only detect_objects function
  static final detectObjects = _lib
      .lookupFunction<ffi.Pointer<Utf8> Function(ffi.Pointer<ffi.Uint8>, ffi.Int32, ffi.Int32), 
                      ffi.Pointer<Utf8> Function(ffi.Pointer<ffi.Uint8>, int, int)>('detect_objects');
}
