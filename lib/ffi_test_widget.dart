import 'dart:ffi' as ffi;
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

  void _callFfi() {
    final helloPtr = SpotitmlNative.helloWorld();
    final helloStr = helloPtr.cast<Utf8>().toDartString();
    final sum = SpotitmlNative.addNumbers(3, 4);
    setState(() {
      helloResult = helloStr;
      addResult = sum;
    });
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
      ],
    );
  }
}
