import '../entities/system_status.dart';

abstract class ISystemRepository {
  SystemStatus getSystemStatus();
}