import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiServiceProvider)),
);
final userProfileProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final result = await ref.read(authRepositoryProvider).me();
  return result.match((l) => throw l, (r) => r);
});

class AuthRepository {
  AuthRepository(this._api);
  final ApiService _api;
  Future<Either<Failure, UserModel>> saveProfile({
    String? name,
    required String nationality,
    required String city,
    required String neighbourhood,
    required List<String> interestTags,
  }) async {
    try {
      final r = await _api.dio.post(
        '/api/auth/profile',
        data: {
          'name': name,
          'nationality': nationality,
          'city': city,
          'neighbourhood': neighbourhood,
          'interestTags': interestTags,
        },
      );
      return Right(UserModel.fromJson(r.data['data']));
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel?>> me() async {
    try {
      final r = await _api.dio.get('/api/auth/me');
      return Right(
        r.data['data'] == null ? null : UserModel.fromJson(r.data['data']),
      );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
