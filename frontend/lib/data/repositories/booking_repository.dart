import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failures.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  ),
);

class BookingRepository {
  BookingRepository(this._api, this._cache);
  final ApiService _api;
  final CacheService _cache;

  Future<Either<Failure, BookingModel>> createBooking({
    required String providerId,
    required DateTime scheduledAt,
    required String notes,
    required double amount,
  }) async {
    try {
      final r = await _api.dio.post(
        '/api/bookings',
        data: {
          'providerId': providerId,
          'scheduledAt': scheduledAt.toIso8601String(),
          'notes': notes,
          'amount': amount,
        },
      );
      return Right(BookingModel.fromJson(r.data['data']));
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<BookingModel>>> myBookings() async {
    const cacheKey = 'bookings:my';
    try {
      final r = await _api.dio.get('/api/bookings/my');
      final data = (r.data['data'] as List? ?? [])
          .map((e) => BookingModel.fromJson(e))
          .toList();
      await _cache.writeJson(cacheKey, data.map((e) => e.toJson()).toList());
      return Right(data);
    } on DioException catch (e) {
      final cached = await _cache.readJson(
        cacheKey,
        (json) => (json as List? ?? [])
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      if (cached != null) return Right(cached);
      return Left(failureFromDio(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
