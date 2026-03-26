class ApiResponse<T> {
  final DateTime timestamp;
  final String message;
  final String severity;
  final T? data;
  final dynamic errors;

  ApiResponse({
    required this.timestamp,
    required this.message,
    required this.severity,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(Object? json)? fromJsonT,
  ]) {
    return ApiResponse<T>(
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      message: json['message']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'INFO',
      data: json.containsKey('data') && json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      errors: json['errors'],
    );
  }

  bool get isSuccess => severity == 'SUCCESS';
  bool get isError => severity == 'ERROR';
  bool get isWarning => severity == 'WARNING';
  bool get isInfo => severity == 'INFO';
}
