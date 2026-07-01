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
    state = await AsyncValue.guard(() async {
      final r = await ref
          .read(authRepositoryProvider)
          .saveProfile(
            nationality: nationality,
            city: city,
            neighbourhood: neighbourhood,
            interestTags: tags,
          );
      r.fold(
        (failure) => throw failure,
        (user) => ref.read(userProfileProvider.notifier).setProfile(user),
      );
    });
  }
}
