import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/cuisine_types.dart';
import '../../core/errors/failures.dart';
import '../../core/localization/l10n.dart';
import '../../data/models/paginated_food_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'food_notifier.dart';
import '../../core/theme/app_theme.dart';

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key});

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  // Strict Design System Color Schemes
  static const Color primaryColor = AppColors.primary;
  static const Color mintBgColor = AppColors.mint;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  String? cuisine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = ref.watch(userProfileProvider).value;
    final cuisines = cuisineTypesForNationality(user?.nationality);
    final filter = FoodFilter(city: user?.city ?? 'Dubai', cuisine: cuisine);
    final provider = foodNotifierProvider(filter);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- TOP SPECIFIED HEADER BANNER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tasteOfHomeBanner,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: goldColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cuisine != null
                            ? l10n.cuisineComforts(cuisine!)
                            : l10n.foodFromHome,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  // IconButton(
                  //   onPressed: () => context.pop(),
                  //   icon: const Icon(
                  //     Icons.arrow_back_ios_new_rounded,
                  //     color: Colors.white,
                  //     size: 18,
                  //   ),
                  // ),
                ],
              ),
            ),

            // --- OVERLAPPING CANVAS SHEET ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SCROLLABLE FILTER PILLS BAR ---
                    Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          for (final c in cuisines)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => cuisine = cuisine == c ? null : c,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cuisine == c
                                        ? primaryColor
                                        : cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: cuisine == c
                                          ? primaryColor
                                          : borderColor,
                                      width: 0.8,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: cuisine == c
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: cuisine == c
                                          ? Colors.white
                                          : textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // --- VERTICAL DATA LIST ATTACHMENT ---
                    Expanded(
                      child: ref
                          .watch(provider)
                          .when(
                            loading: () => const RahaLoadingWidget(),
                            error: (e, _) => RahaErrorWidget(
                              message: e is Failure
                                  ? e.message
                                  : 'Something went wrong',
                              onRetry: () => ref.invalidate(provider),
                            ),
                            data: (food) => food.spots.isEmpty
                                ? _CityExpandingEmptyState(
                                    city: filter.city,
                                    type: l10n.foodSpots,
                                  )
                                : NotificationListener<ScrollEndNotification>(
                                    onNotification: (_) {
                                      ref.read(provider.notifier).loadMore();
                                      return false;
                                    },
                                    child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        4,
                                        16,
                                        24,
                                      ),
                                      itemCount: food.spots.length,
                                      itemBuilder: (context, index) {
                                        final spot = food.spots[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: RahaCard(
                                            onTap: () => context.push(
                                              '/food/${spot.id}',
                                            ),
                                            child: Row(
                                              children: [
                                                // Decorative Boxed Graphic Container
                                                Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    color: mintBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    image:
                                                        spot.photos.isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                              spot.photos.first,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: spot.photos.isEmpty
                                                      ? const Icon(
                                                          Icons
                                                              .restaurant_rounded,
                                                          color: primaryColor,
                                                          size: 20,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(width: 14),

                                                // Metadata Text Area
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        spot.name,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        '${spot.cuisineTypes.join(", ")}  ·  ${spot.districtTag}',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: mutedColor,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),

                                                // Numerical Floating Rating Tag Column
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.star_rounded,
                                                          color: goldColor,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          spot.rating
                                                              .toStringAsFixed(
                                                                1,
                                                              ),
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    textColor,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      spot.priceRange,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: mutedColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when a city has no data yet — gives users a clear, friendly explanation
/// instead of a generic empty inbox icon.
class _CityExpandingEmptyState extends StatelessWidget {
  const _CityExpandingEmptyState({required this.city, required this.type});
  final String city;
  final String type;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE2F3EE),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text('🌍', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.comingToCitySoon(city),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C2433),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.expandingTypeToCity(type, city),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8A9BA8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
