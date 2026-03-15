import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/utils/app_logger.dart';

part 'api_client.g.dart';

/// Custom logging interceptor for API requests and responses.
///
/// Logs all HTTP requests, responses, and errors using the chunked AppLogger
/// to avoid console truncation issues.̄
class LoggingInterceptor extends Interceptor {
  static const String _requestStartKey = 'requestStartTime';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_requestStartKey] = DateTime.now().millisecondsSinceEpoch;

    final message = '''
API REQUEST START
Method: ${options.method}
URL: ${options.uri}
Path: ${options.path}
Headers: ${options.headers}
Query Parameters: ${options.queryParameters}
Data: ${options.data}''';

    AppLogger.logData(message);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startedAt = response.requestOptions.extra[_requestStartKey] as int?;
    final duration =
        startedAt == null
            ? 'unknown'
            : '${DateTime.now().millisecondsSinceEpoch - startedAt}ms';

    final message = '''
API REQUEST SUCCESS
Method: ${response.requestOptions.method}
URL: ${response.requestOptions.uri}
Status Code: ${response.statusCode}
Duration: $duration
Response Headers: ${response.headers}
Response Data: ${response.data}''';

    AppLogger.logData(message);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startedAt = err.requestOptions.extra[_requestStartKey] as int?;
    final duration =
        startedAt == null
            ? 'unknown'
            : '${DateTime.now().millisecondsSinceEpoch - startedAt}ms';

    final message = '''
API REQUEST FAILED
Method: ${err.requestOptions.method}
URL: ${err.requestOptions.uri}
Status Code: ${err.response?.statusCode}
Duration: $duration
Error Type: ${err.type}
Message: ${err.message}
Request Headers: ${err.requestOptions.headers}
Request Data: ${err.requestOptions.data}
Response Data: ${err.response?.data}
Stack Trace: ${err.stackTrace}''';

    AppLogger.logError(message);
    super.onError(err, handler);
  }
}

/// Riverpod provider for the main Dio HTTP client.
///
/// Provides a configured Dio instance with:
/// - Base URL for the dating app API
/// - Custom logging interceptor for debugging
/// - Standard timeout configurations
/// - JSON content type headers
@riverpod
Dio apiClient(ApiClientRef ref) {
  final dio = Dio();

  // Configure base options
  dio.options = BaseOptions(
    baseUrl: 'https://ckn4m91r-3000.inc1.devtunnels.ms',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  // Add logging interceptor for debugging
  dio.interceptors.add(LoggingInterceptor());

  return dio;
}

/// Alternative API client provider for mock/testing environments.
///
/// Can be used to override the main apiClient provider during testing
/// or when the backend API is unavailable.
@riverpod
Dio mockApiClient(MockApiClientRef ref) {
  final dio = Dio();

  dio.options = BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', // Mock API for testing
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  // Add logging interceptor for debugging
  dio.interceptors.add(LoggingInterceptor());

  return dio;
}
