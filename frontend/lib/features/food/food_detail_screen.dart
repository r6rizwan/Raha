import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/models/food_spot_details_model.dart';
import '../../data/repositories/food_repository.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';

final foodDetailProvider = FutureProvider.family<FoodSpotDetailsModel, String>((
  ref,
  spotId,
) async {
  final result = await ref
      .read(foodRepositoryProvider)
      .getFoodPlaceDetails(spotId);
  return result.match((failure) => throw failure, (details) => details);
});

class FoodDetailScreen extends ConsumerWidget {
  const FoodDetailScreen({super.key, required this.spotId});
  final String spotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = foodDetailProvider(spotId);
    return Scaffold(
      body: ref
          .watch(provider)
          .when(
            loading: () => const RahaLoadingWidget(),
            error: (e, _) => RahaErrorWidget(
              message: e is Failure ? e.message : 'Something went wrong',
              onRetry: () => ref.invalidate(provider),
            ),
            data: (details) {
              final spot = details.spot;
              final place = details.place;
              return CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    title: Text(spot.name),
                    expandedHeight: 220,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(context).colorScheme.tertiaryContainer,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.restaurant, size: 72),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          spot.cuisineTypes.join(' • '),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('${spot.districtTag}, ${spot.city}'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(
                                '${place?.rating == 0 || place == null ? spot.rating : place.rating} ★',
                              ),
                            ),
                            Chip(label: Text(spot.priceRange)),
                            if (place?.userRatingCount != null &&
                                place!.userRatingCount > 0)
                              Chip(
                                label: Text(
                                  '${place.userRatingCount} Google reviews',
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (place?.address.isNotEmpty == true)
                          _InfoTile(
                            icon: Icons.place_outlined,
                            title: 'Address',
                            value: place!.address,
                          ),
                        if (place?.phone.isNotEmpty == true)
                          _InfoTile(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: place!.phone,
                          ),
                        if (place?.website.isNotEmpty == true)
                          _InfoTile(
                            icon: Icons.language_outlined,
                            title: 'Website',
                            value: place!.website,
                          ),
                        if (place?.mapsUrl.isNotEmpty == true)
                          _InfoTile(
                            icon: Icons.map_outlined,
                            title: 'Google Maps',
                            value: place!.mapsUrl,
                          ),
                        if (place?.openingHours.isNotEmpty == true) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Opening hours',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          for (final line in place!.openingHours) Text(line),
                        ],
                        if (place == null)
                          const Text(
                            'Google Places details will appear here after a real Google Place ID is attached to this food spot.',
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(value),
  );
}
