import 'package:flutter/foundation.dart';
import '../../data/datasources/camera_service.dart';

class CameraViewModel extends ChangeNotifier {
  final CameraService _cameraService;
  bool _isInitialized = false;
  String _errorMessage = '';
  bool _isProcessing = false;

  CameraViewModel(this._cameraService);

  bool get isInitialized => _isInitialized;
  String get errorMessage => _errorMessage;
  bool get isProcessing => _isProcessing;
  CameraService get cameraService => _cameraService;

  Future<void> initialize() async {
    try {
      await _cameraService.initialize();
      _isInitialized = true;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to initialize camera: ${e.toString()}';
      _isInitialized = false;
    }
    notifyListeners();
  }

  Future<void> captureAndProcessImage() async {
    if (!_isInitialized) return;

    try {
      _isProcessing = true;
      notifyListeners();

      final image = await _cameraService.captureImage();
      // TODO: Implement symbol detection processing
      
    } catch (e) {
      _errorMessage = 'Failed to process image: ${e.toString()}';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}