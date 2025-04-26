import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockPathProviderPlatform extends Mock implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryDirectory() async => '/tmp/test';
  
  @override
  Future<String?> getApplicationSupportPath() async => '/support/test';
  
  @override
  Future<String?> getApplicationDocumentsPath() async => '/documents/test';
  
  @override
  Future<String?> getApplicationCachePath() async => '/cache/test';
  
  @override
  Future<String?> getLibraryPath() async => '/library/test';
  
  @override
  Future<String?> getExternalStoragePath() async => '/storage/test';
  
  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async => ['/storage/test'];
  
  @override
  Future<List<String>?> getExternalCachePaths() async => ['/cache/test'];
  
  @override
  Future<String?> getDownloadsPath() async => '/downloads/test';
}

void setupTestPlatform() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock path provider
  PathProviderPlatform.instance = MockPathProviderPlatform();

  // Mock method channel calls that might be needed
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getTemporaryDirectory':
        return '/tmp/test';
      default:
        return null;
    }
  });
}