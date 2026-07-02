import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/paginated_providers_model.dart';
import '../models/service_provider_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => ServiceRepository(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  ),
);

class ServiceRepository {
  ServiceRepository(this._api, this._cache);
  final ApiService _api;
  final CacheService _cache;

  Future<Either<Failure, PaginatedProvidersModel>> getProviders(
    ServiceFilter filter,
    int page,
  ) async {
    final cacheKey =
        'providers:${filter.city}:${filter.category ?? 'all'}:$page';
    try {
      final r = await _api.dio.get(
        '/api/services',
        queryParameters: {
          'city': filter.city,
          if (filter.category != null) 'category': filter.category,
          'page': page,
          'limit': AppConstants.pageSize,
        },
      );
      final data = PaginatedProvidersModel.fromJson(r.data['data']);
      await _cache.writeJson(cacheKey, data.toJson());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) =>
            PaginatedProvidersModel.fromJson(json as Map<String, dynamic>),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load service providers'));
    }
  }

  Future<Either<Failure, ServiceProviderModel>> getProvider(String id) async {
    final cacheKey = 'provider:$id';
    try {
      final r = await _api.dio.get('/api/services/$id');
      final data = ServiceProviderModel.fromJson(r.data['data']);
      await _cache.writeJson(cacheKey, data.toJson());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => ServiceProviderModel.fromJson(json as Map<String, dynamic>),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(unexpectedFailure('load this service provider'));
    }
  }
}
