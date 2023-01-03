class ExternalError implements Exception {
  final String message;
  final String service;
  final StackTrace stackTrace;

  ExternalError({
    required this.message,
    required this.service,
    required this.stackTrace,
  });

  @override
  String toString() {
    return '$service(message: $message, stackTrace: $stackTrace)';
  }
}
