import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'recommendation_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).value;
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'there';

    return Scaffold(
      appBar: AppBar(title: Text('Hi $name')),
      body: ref
          .watch(recommendationProvider)
          .when(
            loading: () => const RahaLoadingWidget(),
            error: (e, _) => RahaErrorWidget(
              message: e is Failure ? e.message : 'Something went wrong',
              onRetry: () => ref.invalidate(recommendationProvider),
            ),
            data: (items) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Recommended for you',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                for (final item in items)
                  RahaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(item.subtitle),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(item.ctaLabel),
                          ),
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
