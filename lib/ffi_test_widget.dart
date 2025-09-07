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
  String? helloResult;
  int? addResult;
  String? detectResult;

  void _callFfi() {
    final helloPtr = SpotitmlNative.helloWorld();
    final helloStr = helloPtr.cast<Utf8>().toDartString();
    final sum = SpotitmlNative.addNumbers(3, 4);
    
    // Test detect_objects with dummy data
    final dummyImageData = Uint8List(640 * 480 * 3); // RGB image data
    final imagePtr = malloc<ffi.Uint8>(dummyImageData.length);
    
    try {
      imagePtr.asTypedList(dummyImageData.length).setAll(0, dummyImageData);
      final detectPtr = SpotitmlNative.detectObjects(imagePtr, 640, 480);
      final detectStr = detectPtr.cast<Utf8>().toDartString();
      
      setState(() {
        helloResult = helloStr;
        addResult = sum;
        detectResult = detectStr;
      });
    } finally {
      // Always free the allocated memory, even if an exception occurs
      malloc.free(imagePtr);
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
        if (helloResult != null) Text('hello_world: $helloResult'),
        if (addResult != null) Text('add_numbers(3, 4): $addResult'),
        if (detectResult != null) Text('detect_objects: $detectResult'),
      ],
    );
  }
}
