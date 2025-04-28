import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

final class SystemBridge {
  static final DynamicLibrary _lib = Platform.isAndroid
      ? DynamicLibrary.open('libspotitml.so')
      : DynamicLibrary.process();

  static final Pointer<Utf8> Function() _getSystemStatus = _lib
      .lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>(
          'spotitml_get_system_status');

  static String getSystemStatus() {
    final statusPtr = _getSystemStatus();
    final status = statusPtr.toDartString();
    return status;
  }
}