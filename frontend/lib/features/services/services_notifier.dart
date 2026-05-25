import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/paginated_providers_model.dart';
import '../../data/repositories/service_repository.dart';

final serviceNotifierProvider =
    AsyncNotifierProvider.family<
      ServicesNotifier,
      PaginatedProvidersModel,
      ServiceFilter
    >(ServicesNotifier.new);

class ServicesNotifier extends AsyncNotifier<PaginatedProvidersModel> {
  ServicesNotifier(this.filter);
  final ServiceFilter filter;
  bool _loadingMore = false;

  @override
  Future<PaginatedProvidersModel> build() async {
    return (await ref.read(serviceRepositoryProvider).getProviders(filter, 1))
        .match((l) => throw l, (r) => r);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        _loadingMore ||
        current.providers.length >= current.total) {
      return;
    }
    _loadingMore = true;
    final next = await ref
        .read(serviceRepositoryProvider)
        .getProviders(filter, current.page + 1);
    next.match(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(
        current.copyWith(
          providers: [...current.providers, ...r.providers],
          page: r.page,
          total: r.total,
        ),
      ),
    );
    _loadingMore = false;
  }
}
