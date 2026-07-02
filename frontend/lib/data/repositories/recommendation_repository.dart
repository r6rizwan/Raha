import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../models/ai_recommendation_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

final recommendationRepositoryProvider = Provider<RecommendationRepository>(
  (ref) => RecommendationRepository(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  ),
);

class RecommendationRepository {
  RecommendationRepository(this._api, this._cache);
  final ApiService _api;
  final CacheService _cache;

  Future<Either<Failure, List<AIRecommendationModel>>> getRecommendations(
    String uid,
  ) async {
    final cacheKey = 'recommendations:$uid';
    try {
      final r = await _api.dio.get('/api/recommendations/$uid');
      final data = (r.data['data'] as List? ?? [])
          .map((e) => AIRecommendationModel.fromJson(e))
          .toList();
      await _cache.writeJson(cacheKey, data.map((e) => e.toJson()).toList());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => (json as List? ?? [])
            .map(
              (e) => AIRecommendationModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load recommendations'));
    }
  }
}
