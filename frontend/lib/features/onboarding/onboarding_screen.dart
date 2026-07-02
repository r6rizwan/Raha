import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/nationalities.dart';
import '../../core/errors/failures.dart';
import '../../core/router/app_router.dart';
import 'onboarding_notifier.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Design System Colors
  static const Color primaryColor = AppColors.primary;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  String nationality = supportedNationalities.first;
  final city = TextEditingController(text: 'Dubai');
  final neighbourhood = TextEditingController();
  final tags = TextEditingController();

  @override
  void dispose() {
    city.dispose();
    neighbourhood.dispose();
    tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(onboardingNotifierProvider, (previous, next) {
      if (!context.mounted) return;

      if (next.hasError && !next.isLoading) {
        final error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is Failure ? error.message : 'Something went wrong',
            ),
          ),
        );
        return;
      }

      if (previous?.isLoading == true && next.hasValue) {
        context.go(AppRoutes.home);
      }
    });

    final loading = ref.watch(onboardingNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: [
              // Premium App Branding Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Raha',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'رَحة  ·  Setup Your Account',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.65),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Overlapping Input Form Container
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nationality Field
                        _buildFieldLabel('NATIONALITY'),
                        DropdownButtonFormField<String>(
                          initialValue: nationality,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: mutedColor,
                          ),
                          decoration: _buildInputDecoration(),
                          items: supportedNationalities
                              .map(
                                (n) =>
                                    DropdownMenuItem(value: n, child: Text(n)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => nationality = v!),
                        ),
                        const SizedBox(height: 18),

                        // City Field
                        _buildFieldLabel('CITY'),
                        TextField(
                          controller: city,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _buildInputDecoration(),
                        ),
                        const SizedBox(height: 18),

                        // Neighbourhood Field
                        _buildFieldLabel('NEIGHBOURHOOD'),
                        TextField(
                          controller: neighbourhood,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _buildInputDecoration(
                            hint: 'e.g. Dubai Marina, JLT',
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Interests/Tags Field
                        _buildFieldLabel('INTERESTS'),
                        TextField(
                          controller: tags,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _buildInputDecoration(
                            hint:
                                'e.g. Food, Cleaning, Exploring (Comma-separated)',
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 32),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: primaryColor.withValues(
                                alpha: 0.6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: loading
                                ? null
                                : () {
                                    ref
                                        .read(
                                          onboardingNotifierProvider.notifier,
                                        )
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
                                  },
                            child: loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      key: ValueKey(labelText),
      child: Text(
        labelText,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: mutedColor,
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
    );
  }
}
