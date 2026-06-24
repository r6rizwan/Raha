import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/paginated_food_model.dart';
import '../../data/repositories/food_repository.dart';

final foodNotifierProvider =
    AsyncNotifierProvider.family<FoodNotifier, PaginatedFoodModel, FoodFilter>(
      FoodNotifier.new,
    );

class FoodNotifier extends AsyncNotifier<PaginatedFoodModel> {
  FoodNotifier(this.filter);
  final FoodFilter filter;
  bool _loadingMore = false;

  @override
  Future<PaginatedFoodModel> build() async {
    return (await ref.read(foodRepositoryProvider).getFoodSpots(filter, 1))
        .match((l) => throw l, (r) => r);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        _loadingMore ||
        current.spots.length >= current.total) {
      return;
    }
    _loadingMore = true;
    final next = await ref
        .read(foodRepositoryProvider)
        .getFoodSpots(filter, current.page + 1);
    next.match(
      (l) {
        // Keep current data so user doesn't lose their scrolled list upon a transient load-more error
        state = AsyncData(current);
      },
      (r) => state = AsyncData(
        current.copyWith(
          spots: [...current.spots, ...r.spots],
          page: r.page,
          total: r.total,
        ),
      ),
    );
    _loadingMore = false;
  }
}
