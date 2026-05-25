import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_service.dart';
import '../../shared/widgets/raha_empty_widget.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'bookings_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            user?.name ?? 'Raha user',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text('${user?.nationality ?? ''} • ${user?.city ?? 'Dubai'}'),
          const SizedBox(height: 24),
          Text('Bookings', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
            height: 360,
            child: ref
                .watch(bookingNotifierProvider)
                .when(
                  loading: () => const RahaLoadingWidget(),
                  error: (e, _) => RahaErrorWidget(
                    message: e is Failure ? e.message : 'Something went wrong',
                    onRetry: () => ref.invalidate(bookingNotifierProvider),
                  ),
                  data: (bookings) => bookings.isEmpty
                      ? const RahaEmptyWidget(message: 'No bookings yet')
                      : ListView(
                          children: [
                            for (final b in bookings)
                              ListTile(
                                title: Text(b.providerName),
                                subtitle: Text(b.status),
                                trailing: Text(
                                  b.scheduledAt
                                      .toLocal()
                                      .toString()
                                      .split('.')
                                      .first,
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
