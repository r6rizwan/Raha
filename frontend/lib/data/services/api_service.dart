import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import 'auth_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(ref));
const _baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'http://10.0.2.2:5000',
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
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['retried'] != true) {
            final token = await FirebaseAuth.instance.currentUser?.getIdToken(
              true,
            );
            if (token != null) {
              final request = error.requestOptions
                ..extra['retried'] = true
                ..headers['Authorization'] = 'Bearer $token';
              try {
                return handler.resolve(await dio.fetch(request));
              } on DioException catch (retryError) {
                await ref.read(authServiceProvider).signOut();
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
  if (e.response?.statusCode == 429) {
    return const RateLimitFailure('Too many requests');
  }
  if ((e.response?.statusCode ?? 0) >= 500) {
    return const ServerFailure('Server error');
  }
  if (e.response?.statusCode == 401) return const AuthFailure('Unauthorized');
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const NetworkFailure('Connection timed out');
  }
  return NetworkFailure(e.message ?? 'Something went wrong');
}
