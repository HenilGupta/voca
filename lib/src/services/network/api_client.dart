import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/utils/app_logger.dart';

const String kApiBaseUrl = 'https://ckn4m91r-3000.inc1.devtunnels.ms/api#';

abstract final class AuthApiEndpoints {
  static const String signUp = '/auth/signup';
}

/// Custom logging interceptor for API requests and responses.
///
/// Logs all HTTP requests, responses, and errors using the chunked AppLogger
/// to avoid console truncation issues.̄
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final message = '''
REQUEST: ${options.method} ${options.uri}
Headers: ${options.headers}
Query Parameters: ${options.queryParameters}
Data: ${options.data}''';

    AppLogger.logData(message);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final message = '''
RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}
Headers: ${response.headers}
Data: ${response.data}''';

    AppLogger.logData(message);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = '''
ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}
Status Code: ${err.response?.statusCode}
Error Type: ${err.type}
Message: ${err.message}
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
final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Configure base options
  dio.options = BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  // Add logging interceptor for debugging
  dio.interceptors.add(LoggingInterceptor());

  return dio;
});

/// Alternative API client provider for mock/testing environments.
///
/// Can be used to override the main apiClient provider during testing
/// or when the backend API is unavailable.
final mockApiClientProvider = Provider<Dio>((ref) {
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
});
