import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(ref));
const _baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'https://raha-c9e7.onrender.com',
);

class ApiService {
  ApiService(this.ref) {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(
          seconds: AppConstants.connectTimeoutSeconds,
        ),
        receiveTimeout: const Duration(
          seconds: AppConstants.receiveTimeoutSeconds,
        ),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path == '/health' || options.path == '/api/health') {
            return handler.next(options);
          }
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          if (token == null) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.cancel,
                error: 'Missing token',
              ),
            );
          }
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (error, handler) async {
          // Only retry once on 401 with a fresh token.
          // NEVER call signOut() here — a network timeout or server cold-start
          // (common on Render free tier) must not log the user out.
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['retried'] != true) {
            final token = await FirebaseAuth.instance.currentUser
                ?.getIdToken(true);
            if (token != null) {
              final request = error.requestOptions
                ..extra['retried'] = true
                ..headers['Authorization'] = 'Bearer $token';
              try {
                return handler.resolve(await dio.fetch(request));
              } on DioException catch (retryError) {
                // Retry also failed — pass the error through without signing out.
                return handler.reject(retryError);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }
  final Ref ref;
  late final Dio dio;
}

Failure failureFromDio(DioException e) {
  if (e.type == DioExceptionType.cancel) {
    return const AuthFailure('Please sign in again to continue.');
  }
  if (e.response?.statusCode == 429) {
    return const RateLimitFailure(
      'Too many requests right now. Please wait a moment and try again.',
    );
  }
  if ((e.response?.statusCode ?? 0) >= 500) {
    return const ServerFailure(
      'Our server is having trouble right now. Please try again shortly.',
    );
  }
  if (e.response?.statusCode == 401) {
    return const AuthFailure('Your session expired. Please sign in again.');
  }
  if (e.type == DioExceptionType.connectionError) {
    return const NetworkFailure(
      'Unable to reach the server. Check your internet connection and try again.',
    );
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const NetworkFailure(
      'The connection is taking too long. Please try again.',
    );
  }
  return const NetworkFailure(
    'We could not connect right now. Please try again.',
  );
}
