// ignore_for_file: constant_identifier_names
enum ErrorSeverity { ERROR, WARNING, INFO }

class AppException implements Exception {
  final String message;
  final ErrorSeverity severity;
  final int statusCode;
  final dynamic errors; // Can be a validation Map<String, String>

  AppException({
    required this.message,
    required this.severity,
    this.statusCode = 0,
    this.errors,
  });

  factory AppException.fromJson(Map<String, dynamic> json, int code) {
    return AppException(
      message: json['message'] ?? 'An unknown error occurred',
      severity: _parseSeverity(json['severity']),
      statusCode: code,
      errors: json['errors'],
    );
  }

  static ErrorSeverity _parseSeverity(String? severity) {
    switch (severity?.toUpperCase()) {
      case 'WARNING':
        return ErrorSeverity.WARNING;
      case 'INFO':
        return ErrorSeverity.INFO;
      case 'ERROR':
      default:
        return ErrorSeverity.ERROR;
    }
  }

  @override
  String toString() => message;
}
