import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raha/core/localization/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Provide a fresh in-memory SharedPreferences for each test.
    SharedPreferences.setMockInitialValues({});
  });

  test('restores persisted locale on startup', () async {
    SharedPreferences.setMockInitialValues({'selected_locale': 'ar'});

    final initialLocale = await loadPersistedLocale();
    expect(initialLocale, const Locale('ar'));

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith(() => SeedableLocaleNotifier(initialLocale)),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(localeProvider), const Locale('ar'));
  });

  test('persists language selection when changed', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(localeProvider.notifier).setEnglish();

    expect(container.read(localeProvider), const Locale('en'));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('selected_locale'), 'en');
  });

  test('clears persisted locale when useSystem is called', () async {
    SharedPreferences.setMockInitialValues({'selected_locale': 'ar'});

    final container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith(
          () => SeedableLocaleNotifier(const Locale('ar')),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(localeProvider.notifier).useSystem();

    expect(container.read(localeProvider), isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('selected_locale'), isNull);
  });
}
