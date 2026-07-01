import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final onboardingNotifierProvider =
    AsyncNotifierProvider<OnboardingNotifier, void>(OnboardingNotifier.new);

class OnboardingNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}
  Future<void> saveProfile(
    String nationality,
    String city,
    String neighbourhood,
    List<String> tags,
  ) async {
    state = const AsyncLoading();
    final r = await ref
        .read(authRepositoryProvider)
        .saveProfile(
          nationality: nationality,
          city: city,
          neighbourhood: neighbourhood,
          interestTags: tags,
        );
    state = r.match(
      (l) => AsyncError(l, StackTrace.current),
      (user) {
        // Directly set the profile state — no backend re-fetch needed.
        // This avoids Render cold-start timing issues where the re-fetch
        // of /api/auth/me could fail and the router would redirect back.
        ref.read(userProfileProvider.notifier).setProfile(user);
        return const AsyncData(null);
      },
    );
  }
}
