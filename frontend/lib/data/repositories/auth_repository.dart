import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiServiceProvider)),
);
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserModel?>(
      UserProfileNotifier.new,
    );

class UserProfileNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // Give the backend a moment to respond — especially important on first
    // sign-in when the Render server may be waking from sleep.
    await Future.delayed(const Duration(milliseconds: 800));
    final result = await ref.read(authRepositoryProvider).me();
    return result.match((l) => throw l, (r) => r);
  }

  /// Directly set the profile after a successful save — avoids a backend
  /// re-fetch that may fail on Render cold starts.
  void setProfile(UserModel user) {
    state = AsyncData(user);
  }
}

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
      return Left(unexpectedFailure('save your profile'));
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
      return Left(unexpectedFailure('load your profile'));
    }
  }
}
