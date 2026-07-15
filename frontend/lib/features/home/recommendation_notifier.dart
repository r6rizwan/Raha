import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_recommendation_model.dart';
import '../../data/repositories/providers.dart';
import '../../data/repositories/recommendation_repository.dart';
import '../../core/localization/locale_provider.dart';

final recommendationProvider =
    FutureProvider.autoDispose<List<AIRecommendationModel>>((ref) async {
      final user = ref.watch(authStateProvider).value;
      if (user == null) return [];
      
      final locale = ref.watch(localeProvider);
      final lang = locale?.languageCode ?? 'en';

      final r = await ref
          .read(recommendationRepositoryProvider)
          .getRecommendations(user.uid, lang);
      return r.match((l) => throw l, (items) => items);
    });
