class ApiLog {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, String> requestHeaders;
  final String? requestBody;
  final int statusCode;
  final Map<String, String> responseHeaders;
  final String responseBody;
  final String? sqlExecuted;
  final int durationMs;
  final bool isSuccess;

  ApiLog({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    required this.requestHeaders,
    this.requestBody,
    required this.statusCode,
    required this.responseHeaders,
    required this.responseBody,
    this.sqlExecuted,
    required this.durationMs,
    required this.isSuccess,
  });
}
