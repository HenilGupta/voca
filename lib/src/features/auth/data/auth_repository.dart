import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/network/api_client.dart';
import '../../../shared/utils/app_logger.dart';
import '../domain/auth_models.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn(SignInRequest request);
  Future<AuthResponse> signUp(SignUpRequest request);
}

class HttpAuthRepository implements AuthRepository {
  const HttpAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponse> signIn(SignInRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      AppLogger.logError('Auth sign-in error: ${error.message}');
      throw _mapException(error);
    }
  }

  @override
  Future<AuthResponse> signUp(SignUpRequest request) async {
    try {
      final response = await _dio.post('/auth/signup', data: request.toJson());
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      AppLogger.logError('Auth sign-up error: ${error.message}');
      throw _mapException(error);
    }
  }

  AuthFailure _mapException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (statusCode == 400) {
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is Map<String, dynamic>) {
          if (message.entries.isNotEmpty) {
            final firstEntry = message.entries.first;
            return AuthFailure(firstEntry.value.toString(), statusCode: 400);
          }
        }
      }
      return const AuthFailure('Validation failed.', statusCode: 400);
    }

    if (statusCode == 401) {
      return const AuthFailure('Invalid credentials.', statusCode: 401);
    }

    if (statusCode == 409) {
      return const AuthFailure(
        'User with this email already exists.',
        statusCode: 409,
      );
    }

    if (statusCode == 429) {
      return const AuthFailure(
        'Too many login attempts. Please wait a minute and try again.',
        statusCode: 429,
      );
    }

    final fallbackMessage =
        data is Map<String, dynamic>
            ? data['message']?.toString()
            : error.message;
    return AuthFailure(
      fallbackMessage ?? 'Something went wrong. Please try again.',
      statusCode: statusCode,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return HttpAuthRepository(dio);
});
