import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_recommendation_model.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/recommendation_repository.dart';

final recommendationProvider =
    FutureProvider.autoDispose<List<AIRecommendationModel>>((ref) async {
      final user = ref.watch(authStateProvider).value;
      if (user == null) return [];
      final r = await ref
          .read(recommendationRepositoryProvider)
          .getRecommendations(user.uid);
      return r.match((l) => throw l, (items) => items);
    });
