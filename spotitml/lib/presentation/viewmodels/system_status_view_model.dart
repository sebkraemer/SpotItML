import 'package:flutter/foundation.dart';
import '../../domain/entities/system_status.dart';
import '../../domain/usecases/get_system_status.dart';

class SystemStatusViewModel extends ChangeNotifier {
  final GetSystemStatus _getSystemStatus;
  SystemStatus? _status;

  SystemStatusViewModel(this._getSystemStatus);

  SystemStatus? get status => _status;
  bool get isInitialized => _status?.isInitialized ?? false;
  String get statusMessage => _status?.statusMessage ?? 'Not checked';
  String get version => _status?.version ?? 'Unknown';

  void checkStatus() {
    try {
      _status = _getSystemStatus();
      notifyListeners();
    } catch (e) {
      _status = SystemStatus(
        version: 'Error',
        isInitialized: false,
        statusMessage: e.toString(),
      );
      notifyListeners();
    }
  }
}