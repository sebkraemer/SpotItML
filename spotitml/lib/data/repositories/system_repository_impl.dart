import '../../core/ffi/system_bridge.dart';
import '../../domain/entities/system_status.dart';
import '../../domain/repositories/system_repository.dart';

class SystemRepositoryImpl implements ISystemRepository {
  @override
  SystemStatus getSystemStatus() {
    final statusString = SystemBridge.getSystemStatus();
    final parts = statusString.split(':');
    
    if (parts.length != 3) {
      throw Exception('Invalid status format from native code');
    }

    return SystemStatus(
      version: parts[0],
      isInitialized: parts[1] == '1',
      statusMessage: parts[2],
    );
  }
}