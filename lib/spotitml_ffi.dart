import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// Bindings for the native C++ library
class SpotitmlNative {
  static late final ffi.DynamicLibrary _lib = _open();

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

  static final helloWorld = _lib
      .lookupFunction<ffi.Pointer<Utf8> Function(), ffi.Pointer<Utf8> Function()>('hello_world');

  static final addNumbers = _lib
      .lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32), int Function(int, int)>('add_numbers');

  static final detectObjects = _lib
      .lookupFunction<ffi.Pointer<Utf8> Function(ffi.Pointer<ffi.Uint8>, ffi.Int32, ffi.Int32), 
                      ffi.Pointer<Utf8> Function(ffi.Pointer<ffi.Uint8>, int, int)>('detect_objects');
}
