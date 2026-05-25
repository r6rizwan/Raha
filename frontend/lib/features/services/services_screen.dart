import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/service_categories.dart';
import '../../core/errors/failures.dart';
import '../../data/models/paginated_providers_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_empty_widget.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'services_notifier.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});
  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String? category;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;
    final filter = ServiceFilter(
      city: user?.city ?? 'Dubai',
      category: category,
    );
    final provider = serviceNotifierProvider(filter);
    return Scaffold(
      appBar: AppBar(title: const Text('Home services')),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final c in serviceCategories)
                ChoiceChip(
                  label: Text(c),
                  selected: category == c,
                  onSelected: (_) =>
                      setState(() => category = category == c ? null : c),
                ),
            ],
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
                  data: (data) => data.providers.isEmpty
                      ? const RahaEmptyWidget(message: 'No providers found')
                      : ListView(
                          children: [
                            for (final p in data.providers)
                              RahaCard(
                                onTap: () => context.push('/services/${p.id}'),
                                child: ListTile(
                                  title: Text(p.name),
                                  subtitle: Text(
                                    '${p.category} • ${p.priceRange}',
                                  ),
                                  trailing: Text('${p.rating}'),
                                ),
                              ),
                          ],
                        ),
                ),
          ),
        ],
      ),
    );
  }
}
