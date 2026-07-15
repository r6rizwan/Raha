import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'selected_locale';

/// Reads the persisted locale from SharedPreferences before the app starts.
/// Called once in main() so the initial locale is available synchronously.
Future<Locale?> loadPersistedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return _parseLocale(prefs.getString(_kLocaleKey));
}

Locale? _parseLocale(String? code) {
  switch (code) {
    case 'ar':
      return const Locale('ar');
    case 'en':
      return const Locale('en');
    default:
      return null;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  late SharedPreferences _prefs;

  @override
  Locale? build() => null; // overridden via main() → ProviderScope override

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> useSystem() async {
    await _init();
    await _prefs.remove(_kLocaleKey);
    state = null;
  }

  Future<void> setEnglish() async {
    await _init();
    await _prefs.setString(_kLocaleKey, 'en');
    state = const Locale('en');
  }

  Future<void> setArabic() async {
    await _init();
    await _prefs.setString(_kLocaleKey, 'ar');
    state = const Locale('ar');
  }
}

/// Used in [main] to seed the notifier with the locale that was loaded
/// from SharedPreferences before [runApp] was called.
class SeedableLocaleNotifier extends LocaleNotifier {
  SeedableLocaleNotifier(this._seed);
  final Locale? _seed;

  @override
  Locale? build() => _seed;
}
