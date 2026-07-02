import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/food_spot_details_model.dart';
import '../models/food_spot_model.dart';
import '../models/paginated_food_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepository(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  ),
);

class FoodRepository {
  FoodRepository(this._api, this._cache);
  final ApiService _api;
  final CacheService _cache;

  Future<Either<Failure, PaginatedFoodModel>> getFoodSpots(
    FoodFilter filter,
    int page,
  ) async {
    final cacheKey = 'food:v2:${filter.city}:${filter.cuisine ?? 'all'}:$page';
    try {
      final r = await _api.dio.get(
        '/api/food',
        queryParameters: {
          'city': filter.city,
          if (filter.cuisine != null) 'cuisine': filter.cuisine,
          'page': page,
          'limit': AppConstants.pageSize,
        },
      );
      final data = PaginatedFoodModel.fromJson(r.data['data']);
      await _cache.writeJson(cacheKey, data.toJson());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => PaginatedFoodModel.fromJson(json as Map<String, dynamic>),
      );
      if (cached != null) return Right(cached);
      if (e.response?.statusCode == 404) {
        return const Left(NotFoundFailure('No spots found'));
      }
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load food spots'));
    }
  }

  Future<Either<Failure, FoodSpotModel>> getFoodSpot(String id) async {
    final cacheKey = 'food-spot:v2:$id';
    try {
      final r = await _api.dio.get('/api/food/$id');
      final data = FoodSpotModel.fromJson(r.data['data']);
      await _cache.writeJson(cacheKey, data.toJson());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => FoodSpotModel.fromJson(json as Map<String, dynamic>),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load this food spot'));
    }
  }

  Future<Either<Failure, FoodSpotDetailsModel>> getFoodPlaceDetails(
    String id,
  ) async {
    final cacheKey = 'food-place:v2:$id';
    try {
      final r = await _api.dio.get('/api/food/$id/place');
      final data = FoodSpotDetailsModel.fromJson(r.data['data']);
      await _cache.writeJson(cacheKey, data.toJson());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => FoodSpotDetailsModel.fromJson(json as Map<String, dynamic>),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load place details'));
    }
  }
}
