import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../viewmodels/camera_view_model.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final viewModel = context.read<CameraViewModel>();
    await viewModel.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final viewModel = context.read<CameraViewModel>();
    
    // Handle app lifecycle changes
    if (state == AppLifecycleState.inactive) {
      viewModel.cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symbol Detection')),
      body: Consumer<CameraViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isInitialized) {
            return Center(
              child: viewModel.errorMessage.isNotEmpty
                  ? Text(viewModel.errorMessage)
                  : const CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              // Camera preview
              Center(
                child: CameraPreview(viewModel.cameraService.controller!),
              ),
              
              // Capture button and processing indicator
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: viewModel.isProcessing
                      ? const CircularProgressIndicator()
                      : FloatingActionButton(
                          onPressed: viewModel.captureAndProcessImage,
                          child: const Icon(Icons.camera),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}