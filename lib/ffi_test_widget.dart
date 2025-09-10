import 'dart:developer' as developer;
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'spotitml_ffi.dart';

class FfiTestWidget extends StatefulWidget {
  const FfiTestWidget({super.key});

  @override
  State<FfiTestWidget> createState() => _FfiTestWidgetState();
}

class _FfiTestWidgetState extends State<FfiTestWidget> {
  String? detectResult;

  void _callFfi() {
    try {
      developer.log('Starting FFI calls...', name: 'spotitml.ffi');

      // Test detect_objects with dummy data
      final dummyImageData = Uint8List(640 * 480 * 3); // RGB image data
      final imagePtr = malloc<ffi.Uint8>(dummyImageData.length);

      try {
        imagePtr.asTypedList(dummyImageData.length).setAll(0, dummyImageData);
        developer.log('Calling detect_objects...', name: 'spotitml.ffi');
        final detectPtr = SpotitmlNative.detectObjects(imagePtr, 640, 480);
        final detectStr = detectPtr.cast<Utf8>().toDartString();
        print("DEBUG: detect_objects returned: $detectStr");

        setState(() {
          detectResult = detectStr;
        });
        developer.log('setState completed successfully', name: 'spotitml.ffi');
      } finally {
        // Always free the allocated memory, even if an exception occurs
        malloc.free(imagePtr);
      }
    } catch (e, stackTrace) {
      developer.log(
        'FFI call failed',
        name: 'spotitml.ffi',
        error: e,
        stackTrace: stackTrace,
      );
      // Stack trace now handled by developer.log above

      setState(() {
        detectResult = "ERROR: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _callFfi,
          child: const Text('Call FFI functions'),
        ),
        if (detectResult != null) Text('detect_objects: $detectResult'),
      ],
    );
  }
}
