import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;
  CameraController? get controller => _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras available');
    }
    
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS 
          ? ImageFormatGroup.bgra8888 
          : ImageFormatGroup.yuv420,
    );
    
    await _controller!.initialize();
  }

  Future<XFile> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    return await _controller!.takePicture();
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}