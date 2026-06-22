import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'recommendation_notifier.dart';
import '../../core/theme/app_theme.dart';

import '../../data/services/update_checker_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Strict Design System Color Schemes
  static const Color primaryColor = AppColors.primary;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color darkHeroColor = AppColors.text;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performVersionCheck(context, ref, '1.0.0');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'Rizwan';

    final recommendationState = ref.watch(recommendationProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- TOP HEADER BANNER (Good morning, Hi Rizwan) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hi, $name',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  // Top Right Round Avatar Badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: goldColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'R',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- MAIN CANVAS OVERLAY CONTAINER ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: recommendationState.when(
                  loading: () => const RahaLoadingWidget(),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: RahaErrorWidget(
                      message: e is Failure
                          ? e.message
                          : 'Something went wrong',
                      onRetry: () => ref.invalidate(recommendationProvider),
                    ),
                  ),
                  data: (items) => ListView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                    children: [
                      if (items.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            final item = items.first;
                            if (item.type == 'food') {
                              if (item.referenceId.isNotEmpty) {
                                context.push('/food/${item.referenceId}');
                              } else {
                                context.go('/food');
                              }
                            } else if (item.type == 'service') {
                              if (item.referenceId.isNotEmpty) {
                                context.push('/services/${item.referenceId}');
                              } else {
                                context.go('/services');
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: darkHeroColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: goldColor.withValues(alpha: 0.3),
                                    border: Border.all(
                                      color: goldColor,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'AI PICK FOR YOU',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: goldColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  items.first.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  items.first.subtitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // --- AI PICKS SECTION ---
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          'AI Picks for You',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: _kAiPicks.map((pick) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () => context.go('/food'),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    width: 160,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Background image colour (placeholder until real images)
                                        Container(color: pick['color'] as Color),
                                        // Gradient overlay
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withValues(alpha: 0.65),
                                              ],
                                              stops: const [0.4, 1.0],
                                            ),
                                          ),
                                        ),
                                        // Top-left badge
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: goldColor,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              '✦ AI Pick',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF2C1A00),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Top-right icon
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.restaurant_rounded,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Bottom info
                                        Positioned(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pick['name'] as String,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      pick['cuisine'] as String,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white.withValues(alpha: 0.75),
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 12,
                                                    color: goldColor,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    '${pick['rating']}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- EXPLORE & DISCOVER SECTION ---
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          'Explore & Discover',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      _buildDiscoverCard(
                        icon: Icons.brunch_dining_rounded,
                        iconBg: const Color(0xFFE2F3EE),
                        iconColor: primaryColor,
                        title: 'Best Friday Brunch Spots',
                        subtitle: 'Top picks loved by expats across Dubai.',
                        actionLabel: 'Read →',
                        onTap: () => context.go('/food'),
                      ),
                      const SizedBox(height: 10),
                      _buildDiscoverCard(
                        icon: Icons.air_rounded,
                        iconBg: const Color(0xFFFEF3E2),
                        iconColor: goldColor,
                        title: 'Affordable AC Repair',
                        subtitle: 'Verified technicians, starting AED 80.',
                        actionLabel: 'Book →',
                        onTap: () => context.go('/services'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data for the AI Picks horizontal scroll
  static const List<Map<String, Object>> _kAiPicks = [
    {
      'name': "Ravi's Kitchen",
      'cuisine': 'Indian',
      'rating': 4.8,
      'color': Color(0xFF2D4A3E),
    },
    {
      'name': 'Noodle House',
      'cuisine': 'Filipino',
      'rating': 4.6,
      'color': Color(0xFF4A2D2D),
    },
    {
      'name': 'Spice Route',
      'cuisine': 'Indian',
      'rating': 4.9,
      'color': Color(0xFF2D3A4A),
    },
    {
      'name': 'Al Safadi',
      'cuisine': 'Lebanese',
      'rating': 4.7,
      'color': Color(0xFF3A2D4A),
    },
  ];

  Widget _buildDiscoverCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: mutedColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

