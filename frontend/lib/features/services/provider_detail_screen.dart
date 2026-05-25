import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/models/service_provider_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'booking_sheet.dart';

final providerDetailProvider =
    FutureProvider.family<ServiceProviderModel, String>((
      ref,
      providerId,
    ) async {
      final result = await ref
          .read(serviceRepositoryProvider)
          .getProvider(providerId);
      return result.match((failure) => throw failure, (provider) => provider);
    });

class ProviderDetailScreen extends ConsumerWidget {
  const ProviderDetailScreen({super.key, required this.providerId});
  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = providerDetailProvider(providerId);
    return Scaffold(
      body: ref
          .watch(provider)
          .when(
            loading: () => const RahaLoadingWidget(),
            error: (e, _) => RahaErrorWidget(
              message: e is Failure ? e.message : 'Something went wrong',
              onRetry: () => ref.invalidate(provider),
            ),
            data: (item) => CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  title: Text(item.name),
                  expandedHeight: 220,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondaryContainer,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: const Icon(Icons.handyman, size: 72),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.list(
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text(item.category)),
                          Chip(label: Text('${item.rating} ★')),
                          Chip(label: Text(item.priceRange)),
                          if (item.isVerified)
                            const Chip(label: Text('Verified')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.bio,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_city_outlined),
                        title: const Text('City'),
                        subtitle: Text(item.city),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.phone_outlined),
                        title: const Text('Contact'),
                        subtitle: Text(item.contactPhone),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BookingSheet(provider: item),
                        ),
                        child: const Text('Book this provider'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
