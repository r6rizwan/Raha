import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/cuisine_types.dart';
import '../../core/errors/failures.dart';
import '../../data/models/paginated_food_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_empty_widget.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'food_notifier.dart';

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key});
  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  String? cuisine;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;
    final cuisines =
        cuisineTypesByNationality[user?.nationality] ??
        ['Indian', 'Filipino', 'Pakistani', 'Lebanese'];
    final filter = FoodFilter(city: user?.city ?? 'Dubai', cuisine: cuisine);
    final provider = foodNotifierProvider(filter);
    return Scaffold(
      appBar: AppBar(title: const Text('Food from home')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              children: [
                for (final c in cuisines)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: cuisine == c,
                      onSelected: (_) =>
                          setState(() => cuisine = cuisine == c ? null : c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ref
                .watch(provider)
                .when(
                  loading: () => const RahaLoadingWidget(),
                  error: (e, _) => RahaErrorWidget(
                    message: e is Failure ? e.message : 'Something went wrong',
                    onRetry: () => ref.invalidate(provider),
                  ),
                  data: (food) => food.spots.isEmpty
                      ? const RahaEmptyWidget(message: 'No spots found nearby')
                      : NotificationListener<ScrollEndNotification>(
                          onNotification: (_) {
                            ref.read(provider.notifier).loadMore();
                            return false;
                          },
                          child: ListView(
                            children: [
                              for (final spot in food.spots)
                                RahaCard(
                                  onTap: () => context.push('/food/${spot.id}'),
                                  child: ListTile(
                                    title: Text(spot.name),
                                    subtitle: Text(
                                      '${spot.cuisineTypes.join(', ')} • ${spot.districtTag}',
                                    ),
                                    trailing: Text('${spot.rating}'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
          ),
        ],
      ),
    );
  }
}
