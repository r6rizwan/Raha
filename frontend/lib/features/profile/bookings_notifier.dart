import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

final bookingNotifierProvider =
    AsyncNotifierProvider<BookingNotifier, List<BookingModel>>(
      BookingNotifier.new,
    );

class BookingNotifier extends AsyncNotifier<List<BookingModel>> {
  @override
  Future<List<BookingModel>> build() async =>
      (await ref.read(bookingRepositoryProvider).myBookings()).match(
        (l) => throw l,
        (r) => r,
      );
  Future<void> createBooking({
    required String providerId,
    required DateTime scheduledAt,
    required String notes,
    required double amount,
  }) async {
    final r = await ref
        .read(bookingRepositoryProvider)
        .createBooking(
          providerId: providerId,
          scheduledAt: scheduledAt,
          notes: notes,
          amount: amount,
        );
    r.match((l) => throw l, (_) => ref.invalidateSelf());
  }
}
