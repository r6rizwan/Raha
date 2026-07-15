import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/errors/failures.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/food_place_details_model.dart';
import '../../data/models/food_spot_details_model.dart';
import '../../data/repositories/food_repository.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';

final foodDetailProvider = FutureProvider.family<FoodSpotDetailsModel, String>((
  ref,
  spotId,
) async {
  final result = await ref
      .read(foodRepositoryProvider)
      .getFoodPlaceDetails(spotId);
  return result.match((failure) => throw failure, (details) => details);
});

class FoodDetailScreen extends ConsumerWidget {
  const FoodDetailScreen({super.key, required this.spotId});
  final String spotId;

  static const Color primaryColor = AppColors.primary;
  static const Color mintBgColor = AppColors.mint;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = foodDetailProvider(spotId);

    return Scaffold(
      backgroundColor: primaryColor,
      body: ref
          .watch(provider)
          .when(
            loading: () => const RahaLoadingWidget(),
            error: (e, _) => RahaErrorWidget(
              message: e is Failure
                  ? e.message
                  : context.l10n.somethingWentWrong,
              onRetry: () => ref.invalidate(provider),
            ),
            data: (details) {
              final spot = details.spot;
              final place = details.place;
              final placeRating = place?.rating ?? 0;
              final displayRating = placeRating > 0 ? placeRating : spot.rating;
              final heroPhoto = _heroPhoto(
                spot.photos,
                place?.photoNames ?? const [],
              );

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    stretch: true,
                    elevation: 0,
                    backgroundColor: primaryColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        top: 8,
                        bottom: 8,
                      ),
                      child: _GlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (heroPhoto != null)
                            Image.network(heroPhoto, fit: BoxFit.cover)
                          else
                            Container(
                              color: primaryColor,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.restaurant_rounded,
                                size: 64,
                                color: mintBgColor,
                              ),
                            ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.45),
                                  Colors.black.withValues(alpha: 0.05),
                                  primaryColor.withValues(alpha: 0.95),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        spot.name,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: textColor,
                                          letterSpacing: -0.8,
                                          height: 1.05,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 15,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              '${spot.districtTag}, ${spot.city}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: mutedColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _LiveBadge(isLive: place != null),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                  icon: Icons.star_rounded,
                                  label:
                                      '${displayRating.toStringAsFixed(1)} ${l10n.ratingSuffix}',
                                  color: Colors.white,
                                  bgColor: primaryColor,
                                ),
                                _InfoChip(
                                  icon: Icons.restaurant_menu_rounded,
                                  label: spot.cuisineTypes.isEmpty
                                      ? l10n.cuisine
                                      : spot.cuisineTypes.take(2).join(' • '),
                                  color: primaryColor,
                                  bgColor: mintBgColor,
                                ),
                                if (spot.priceRange.isNotEmpty)
                                  _InfoChip(
                                    icon: Icons.payments_outlined,
                                    label: spot.priceRange,
                                    color: goldColor,
                                    bgColor: AppColors.warmBg,
                                  ),
                                if (place != null && place.userRatingCount > 0)
                                  _InfoChip(
                                    icon: Icons.rate_review_outlined,
                                    label: l10n.reviewsCount(place.userRatingCount),
                                    color: AppColors.violet,
                                    bgColor: AppColors.violetBg,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            _ActionGrid(place: place),
                            const SizedBox(height: 26),
                            _SectionTitle(l10n.details),
                            const SizedBox(height: 12),
                            _DetailsCard(spotCity: spot.city, place: place),
                            if (place?.openingHours.isNotEmpty == true) ...[
                              const SizedBox(height: 26),
                              _SectionTitle(l10n.openingHours),
                              const SizedBox(height: 12),
                              _ExpandableHoursCard(openingHours: place!.openingHours),
                            ],
                            if (place == null) ...[
                              const SizedBox(height: 18),
                              _FallbackNote(googlePlaceId: spot.googlePlaceId),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  String? _heroPhoto(List<String> spotPhotos, List<String> placePhotos) {
    if (placePhotos.isNotEmpty) return placePhotos.first;
    if (spotPhotos.isNotEmpty) return spotPhotos.first;
    return null;
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.black.withValues(alpha: 0.24),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 19),
    ),
  );
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.isLive});
  final bool isLive;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: isLive ? FoodDetailScreen.mintBgColor : AppColors.warmBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      isLive ? context.l10n.livePlaces : context.l10n.localData,
      style: TextStyle(
        color: isLive
            ? FoodDetailScreen.primaryColor
            : FoodDetailScreen.goldColor,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.place});
  final FoodPlaceDetailsModel? place;

  @override
  Widget build(BuildContext context) {
    final actions = [
      if (place?.mapsUrl.isNotEmpty == true)
        _ActionSpec(
          icon: Icons.directions_rounded,
          label: context.l10n.directions,
          onTap: () => launchUrl(
            Uri.parse(place!.mapsUrl),
            mode: LaunchMode.externalApplication,
          ),
        ),
      if (place?.phone.isNotEmpty == true)
        _ActionSpec(
          icon: Icons.phone_rounded,
          label: context.l10n.call,
          onTap: () => launchUrl(Uri.parse('tel:${place!.phone}')),
        ),
    ];

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (final action in actions) ...[
          Expanded(child: _ActionButton(spec: action)),
          if (action != actions.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _ActionSpec {
  const _ActionSpec({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.spec});
  final _ActionSpec spec;

  @override
  Widget build(BuildContext context) => Material(
    color: FoodDetailScreen.cardColor,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: spec.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: FoodDetailScreen.borderColor, width: 0.8),
        ),
        child: Column(
          children: [
            Icon(spec.icon, color: FoodDetailScreen.primaryColor, size: 22),
            const SizedBox(height: 7),
            Text(
              spec.label,
              style: const TextStyle(
                color: FoodDetailScreen.textColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      color: FoodDetailScreen.textColor,
      fontSize: 18,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.4,
    ),
  );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.spotCity, required this.place});
  final String spotCity;
  final FoodPlaceDetailsModel? place;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: FoodDetailScreen.cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: FoodDetailScreen.borderColor, width: 0.7),
    ),
    child: Column(
      children: [
        _DetailRow(
          icon: Icons.place_outlined,
          title: context.l10n.location,
          value: place?.address.isNotEmpty == true ? place!.address : spotCity,
          onTap: place?.mapsUrl.isNotEmpty == true
              ? () => launchUrl(
                  Uri.parse(place!.mapsUrl),
                  mode: LaunchMode.externalApplication,
                )
              : null,
        ),
        if (place?.phone.isNotEmpty == true)
          _DetailRow(
            icon: Icons.phone_outlined,
            title: context.l10n.phone,
            value: place!.phone,
            onTap: () => launchUrl(Uri.parse('tel:${place!.phone}')),
          ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FoodDetailScreen.mintBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: FoodDetailScreen.primaryColor, size: 19),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: FoodDetailScreen.mutedColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: FoodDetailScreen.textColor,
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: FoodDetailScreen.mutedColor,
              ),
          ],
        ),
      ),
    ),
  );
}

class _ExpandableHoursCard extends StatefulWidget {
  const _ExpandableHoursCard({required this.openingHours});
  final List<String> openingHours;

  @override
  State<_ExpandableHoursCard> createState() => _ExpandableHoursCardState();
}

class _ExpandableHoursCardState extends State<_ExpandableHoursCard> {
  bool _isExpanded = false;

  String _getTodayTiming() {
    if (widget.openingHours.isEmpty) {
      return context.l10n.openingHoursUnavailable;
    }
    final todayIndex = DateTime.now().weekday - 1; // 0 = Monday, 6 = Sunday
    if (todayIndex >= 0 && todayIndex < widget.openingHours.length) {
      return widget.openingHours[todayIndex];
    }
    return widget.openingHours.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.openingHours.isEmpty) return const SizedBox.shrink();
    
    final todayTiming = _getTodayTiming();
    int colonIdx = todayTiming.indexOf(': ');
    final todayDay = colonIdx != -1
        ? todayTiming.substring(0, colonIdx)
        : context.l10n.todayLabel;
    final todayHours = colonIdx != -1 ? todayTiming.substring(colonIdx + 2) : todayTiming;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: FoodDetailScreen.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FoodDetailScreen.borderColor, width: 0.7),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: FoodDetailScreen.primaryColor,
                      size: 19,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.todayWithDay(todayDay),
                            style: const TextStyle(
                              color: FoodDetailScreen.mutedColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todayHours,
                            style: const TextStyle(
                              color: FoodDetailScreen.textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: FoodDetailScreen.mutedColor,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  for (final line in widget.openingHours) ...[
                    Builder(
                      builder: (context) {
                        int idx = line.indexOf(': ');
                        String day = idx != -1 ? line.substring(0, idx) : line;
                        String hours = idx != -1 ? line.substring(idx + 2) : '';
                        bool isToday = day == todayDay;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: isToday ? FoodDetailScreen.primaryColor : FoodDetailScreen.mutedColor,
                                    fontSize: 13,
                                    fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  hours,
                                  style: TextStyle(
                                    color: isToday ? FoodDetailScreen.textColor : FoodDetailScreen.mutedColor,
                                    fontSize: 13,
                                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FallbackNote extends StatelessWidget {
  const _FallbackNote({required this.googlePlaceId});
  final String googlePlaceId;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.warmBg,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: FoodDetailScreen.goldColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            googlePlaceId.startsWith('seed-')
                ? context.l10n.seedFallbackNote
                : context.l10n.livePlacesUnavailable,
            style: const TextStyle(
              color: FoodDetailScreen.goldColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}
