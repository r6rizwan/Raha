import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/nationalities.dart';
import '../../core/router/app_router.dart';
import 'onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String nationality = supportedNationalities.first;
  final city = TextEditingController(text: 'Dubai');
  final neighbourhood = TextEditingController();
  final tags = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(onboardingNotifierProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Set up Raha')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField(
            initialValue: nationality,
            items: supportedNationalities
                .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                .toList(),
            onChanged: (v) => setState(() => nationality = v!),
            decoration: const InputDecoration(labelText: 'Nationality'),
          ),
          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          TextField(
            controller: neighbourhood,
            decoration: const InputDecoration(labelText: 'Neighbourhood'),
          ),
          TextField(
            controller: tags,
            decoration: const InputDecoration(
              labelText: 'Interests, comma separated',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: loading
                ? null
                : () async {
                    await ref
                        .read(onboardingNotifierProvider.notifier)
                        .saveProfile(
                          nationality,
                          city.text,
                          neighbourhood.text,
                          tags.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList(),
                        );
                    if (context.mounted &&
                        !ref.read(onboardingNotifierProvider).hasError) {
                      context.go(AppRoutes.home);
                    }
                  },
            child: loading
                ? const CircularProgressIndicator()
                : const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
