class SystemStatus {
  final String version;
  final bool isInitialized;
  final String statusMessage;

  const SystemStatus({
    required this.version,
    required this.isInitialized,
    required this.statusMessage,
  });

  @override
  String toString() => 'SystemStatus(version: $version, isInitialized: $isInitialized, message: $statusMessage)';
}