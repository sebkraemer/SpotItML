import 'dart:developer' as developer;
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'package:camera/camera.dart';
import 'spotitml_ffi.dart';

class CameraDetectionWidget extends StatefulWidget {
  const CameraDetectionWidget({super.key});

  @override
  State<CameraDetectionWidget> createState() => _CameraDetectionWidgetState();
}

class _CameraDetectionWidgetState extends State<CameraDetectionWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String? _detectionResult;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0], // Use the first available camera
          ResolutionPreset.medium,
        );
        
        await _controller!.initialize();
        
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      developer.log('Error initializing camera: $e', name: 'spotitml.camera');
      setState(() {
        _detectionResult = 'Camera initialization failed: $e';
      });
    }
  }

  Future<void> _detectObjects() async {
    if (_controller == null || !_controller!.value.isInitialized || _isDetecting) {
      return;
    }

    setState(() {
      _isDetecting = true;
      _detectionResult = 'Processing...';
    });

    try {
      developer.log('Starting object detection...', name: 'spotitml.detection');
      
      // Capture image from camera
      final XFile imageFile = await _controller!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      developer.log('Captured image, size: ${imageBytes.length} bytes', name: 'spotitml.detection');
      
      // For now, we'll pass dummy dimensions and the image data to FFI
      // In a real implementation, we'd need to decode the image and convert to RGB
      final imagePtr = malloc<ffi.Uint8>(imageBytes.length);
      
      try {
        imagePtr.asTypedList(imageBytes.length).setAll(0, imageBytes);
        developer.log('Calling detect_objects via FFI...', name: 'spotitml.ffi');
        
        // Use image dimensions (this is a simplification - real implementation 
        // would need proper image decoding)
        final detectPtr = SpotitmlNative.detectObjects(imagePtr, 640, 480);
        final detectStr = detectPtr.cast<Utf8>().toDartString();
        developer.log('FFI returned: $detectStr', name: 'spotitml.ffi');
        
        setState(() {
          _detectionResult = detectStr;
          _isDetecting = false;
        });
        
      } finally {
        malloc.free(imagePtr);
      }
    } catch (e, stackTrace) {
      developer.log('Detection failed', name: 'spotitml.detection', error: e, stackTrace: stackTrace);
      // Stack trace now handled by developer.log above
      
      setState(() {
        _detectionResult = "Detection error: $e";
        _isDetecting = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing Camera...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Camera preview
        Expanded(
          flex: 3,
          child: SizedBox(
            width: double.infinity,
            child: CameraPreview(_controller!),
          ),
        ),
        
        // Detection button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isDetecting ? null : _detectObjects,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isDetecting 
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Detecting...'),
                  ],
                )
              : const Text('Detect Objects'),
          ),
        ),
        
        // Detection results
        if (_detectionResult != null)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _detectionResult!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}