import '../entities/system_status.dart';
import '../repositories/system_repository.dart';

class GetSystemStatus {
  final ISystemRepository repository;

  GetSystemStatus(this.repository);

  SystemStatus call() {
    return repository.getSystemStatus();
  }
}