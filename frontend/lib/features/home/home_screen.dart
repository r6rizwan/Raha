import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/cuisine_types.dart';
import '../../core/localization/l10n.dart';
import '../../core/constants/service_categories.dart';
import '../../core/errors/failures.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_recommendation_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/update_checker_service.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import '../profile/bookings_notifier.dart';
import 'recommendation_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const Color primaryColor = AppColors.primary;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performVersionCheck(context, ref, '1.0.1');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final l10n = context.l10n;
    final name = profile?.name.isNotEmpty == true ? profile!.name : l10n.friend;
    final recommendationState = ref.watch(recommendationProvider);
    final bookingState = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                        _greetingForNow(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.68),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.hiName(name),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: goldColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: goldColor.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'R',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                    children: [
                      _buildHero(profile, items),
                      const SizedBox(height: 18),
                      _sectionTitle(
                        l10n.quickActions,
                        l10n.quickActionsSubtitle,
                      ),
                      const SizedBox(height: 12),
                      _buildQuickActions(context),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.madeForYourBase,
                        profile?.city.isNotEmpty == true
                            ? l10n.usefulPicksAround(profile!.city)
                            : l10n.usefulPicksRoutine,
                      ),
                      const SizedBox(height: 12),
                      _buildContextCard(profile),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.tasteOfHome,
                        l10n.tasteOfHomeSubtitle,
                      ),
                      const SizedBox(height: 12),
                      _buildCuisineRail(context, profile),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.bookServiceFast,
                        l10n.bookServiceFastSubtitle,
                      ),
                      const SizedBox(height: 12),
                      _buildServiceRail(context),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.recentBooking,
                        l10n.recentBookingSubtitle,
                      ),
                      const SizedBox(height: 12),
                      _buildRecentBooking(context, bookingState),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.aiPicksForYou,
                        l10n.aiPicksSubtitle,
                      ),
                      const SizedBox(height: 12),
                      _buildRecommendationRail(context, items),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        l10n.recommendedNow,
                        l10n.recommendedNowSubtitle,
                      ),
                      const SizedBox(height: 12),
                      ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildRecommendationCard(context, item),
                          )),
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

  Widget _buildHero(UserModel? profile, List<AIRecommendationModel> items) {
    final hero = items.isNotEmpty ? items.first : null;
    final l10n = context.l10n;
    final location = profile?.city.isNotEmpty == true ? profile!.city : 'UAE';
    final neighbourhood = profile?.neighbourhood.isNotEmpty == true
        ? profile!.neighbourhood
        : 'your area';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF113B31),
            Color(0xFF0A5D4B),
            Color(0xFF1C7A63),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: goldColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: goldColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  l10n.rahaToday,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: goldColor,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            hero?.title ?? l10n.heroDefaultTitle,
            style: const TextStyle(
              fontSize: 24,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hero?.subtitle ??
                l10n.heroDefaultSubtitle(neighbourhood),
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _heroStat(Icons.location_on_rounded, location),
              _heroStat(
                Icons.flag_rounded,
                profile?.nationality.isNotEmpty == true
                    ? profile!.nationality
                    : 'Expat life',
              ),
              _heroStat(Icons.explore_rounded, hero?.ctaLabel ?? 'Explore'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: goldColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _quickActionTile(
            icon: Icons.restaurant_menu_rounded,
            title: context.l10n.findFood,
            subtitle: context.l10n.homeFlavours,
            accent: const Color(0xFFE4F4EF),
            iconColor: primaryColor,
            onTap: () => context.go('/food'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _quickActionTile(
            icon: Icons.home_repair_service_rounded,
            title: context.l10n.bookHelp,
            subtitle: context.l10n.cleaningAndMore,
            accent: const Color(0xFFFFF3DF),
            iconColor: const Color(0xFF946200),
            onTap: () => context.go('/services'),
          ),
        ),
      ],
    );
  }

  Widget _quickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextCard(UserModel? profile) {
    final location = profile?.city.isNotEmpty == true ? profile!.city : 'UAE';
    final neighbourhood = profile?.neighbourhood.isNotEmpty == true
        ? profile!.neighbourhood
        : 'your neighbourhood';
    final interests = profile?.interestTags.where((tag) => tag.isNotEmpty).toList() ?? const <String>[];

    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3EF),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.apartment_rounded,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cityRhythm(location),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.builtAround(neighbourhood),
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(Icons.location_pin, location),
              if (profile?.nationality.isNotEmpty == true)
                _infoChip(Icons.flag_circle_rounded, profile!.nationality),
              if (interests.isEmpty)
                _infoChip(Icons.favorite_rounded, l10n.generalLifestyle)
              else
                ...interests.take(3).map((tag) => _infoChip(Icons.local_fire_department_rounded, tag)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2EA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineRail(BuildContext context, UserModel? profile) {
    final cuisines = cuisineTypesForNationality(profile?.nationality).take(6).toList();

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cuisines.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final cuisine = cuisines[index];
          return GestureDetector(
            onTap: () => context.go('/food'),
            child: Container(
              width: 128,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: index.isEven ? const Color(0xFFF5EEDF) : const Color(0xFFE8F3EF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    index.isEven ? Icons.ramen_dining_rounded : Icons.restaurant_rounded,
                    color: primaryColor,
                  ),
                  const Spacer(),
                  Text(
                    cuisine,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.openFoodFeed,
                    style: TextStyle(
                      fontSize: 11,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceRail(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: serviceCategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final category = serviceCategories[index];
          return GestureDetector(
            onTap: () => context.go('/services'),
            child: Container(
              width: 144,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _serviceIcon(category),
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.browseProviders,
                    style: TextStyle(fontSize: 11, color: mutedColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBooking(
    BuildContext context,
    AsyncValue<List<BookingModel>> bookingState,
  ) {
    return bookingState.when(
      loading: () => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          context.l10n.loadingLatestBooking,
          style: TextStyle(
            fontSize: 13,
            color: mutedColor,
          ),
        ),
      ),
      error: (_, _) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          context.l10n.bookingHistoryAppear,
          style: TextStyle(
            fontSize: 13,
            color: mutedColor,
          ),
        ),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return GestureDetector(
            onTap: () => context.go('/services'),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3DF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF946200),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.noBookingsYet,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          context.l10n.noBookingsYetSubtitle,
                          style: TextStyle(fontSize: 12, color: mutedColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final booking = bookings.first;
        return GestureDetector(
          onTap: () => context.go('/profile'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3EF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _bookingStatusIcon(booking.status),
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.providerName.isNotEmpty
                            ? booking.providerName
                            : context.l10n.serviceBooking,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${toBeginningOfSentenceCase(booking.status)} · ${DateFormat('EEE, d MMM · h:mm a').format(booking.scheduledAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationRail(
    BuildContext context,
    List<AIRecommendationModel> items,
  ) {
    if (items.length <= 1) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          context.l10n.moreRecommendations,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: mutedColor,
          ),
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length - 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final item = items[index + 1];
          final config = _recommendationStyle(item.type);
          return GestureDetector(
            onTap: () => _openRecommendation(context, item),
            child: Container(
              width: 182,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    config.$1,
                    config.$1.withValues(alpha: 0.82),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: goldColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.ctaLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C1A00),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(config.$2, size: 18, color: Colors.white),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    AIRecommendationModel item,
  ) {
    final config = _recommendationStyle(item.type);
    return GestureDetector(
      onTap: () => _openRecommendation(context, item),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: config.$1.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(config.$2, color: config.$1),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: mutedColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.ctaLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: mutedColor,
            ),
          ),
        ],
      ),
    );
  }

  void _openRecommendation(BuildContext context, AIRecommendationModel item) {
    if (item.type == 'food') {
      if (item.referenceId.isNotEmpty) {
        context.push('/food/${item.referenceId}');
      } else {
        context.go('/food');
      }
      return;
    }

    if (item.type == 'service') {
      if (item.referenceId.isNotEmpty) {
        context.push('/services/${item.referenceId}');
      } else {
        context.go('/services');
      }
      return;
    }

    context.go('/food');
  }

  (Color, IconData) _recommendationStyle(String type) {
    switch (type) {
      case 'service':
        return (const Color(0xFF7A5430), Icons.home_repair_service_rounded);
      case 'tip':
        return (const Color(0xFF304D7A), Icons.lightbulb_rounded);
      case 'food':
      default:
        return (const Color(0xFF1F6A54), Icons.restaurant_rounded);
    }
  }

  IconData _serviceIcon(String category) {
    switch (category) {
      case 'Cleaning':
        return Icons.cleaning_services_rounded;
      case 'Maintenance':
        return Icons.build_circle_rounded;
      case 'Movers':
        return Icons.local_shipping_rounded;
      case 'Handyman':
      default:
        return Icons.handyman_rounded;
    }
  }

  IconData _bookingStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'pending':
      default:
        return Icons.schedule_rounded;
    }
  }

  String _greetingForNow() {
    final hour = DateTime.now().hour;
    if (hour < 12) return context.l10n.goodMorning;
    if (hour < 18) return context.l10n.goodAfternoon;
    return context.l10n.goodEvening;
  }
}
