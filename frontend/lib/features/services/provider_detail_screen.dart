import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/failures.dart';
import '../../data/models/service_provider_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'booking_sheet.dart';
import '../../core/theme/app_theme.dart';

final providerDetailProvider =
    FutureProvider.family<ServiceProviderModel, String>((
      ref,
      providerId,
    ) async {
      final result = await ref
          .read(serviceRepositoryProvider)
          .getProvider(providerId);
      return result.match((failure) => throw failure, (provider) => provider);
    });

class ProviderDetailScreen extends ConsumerWidget {
  const ProviderDetailScreen({super.key, required this.providerId});
  final String providerId;

  // Strict Design System Color Schemes
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
    final provider = providerDetailProvider(providerId);

    return ref
        .watch(provider)
        .when(
          loading: () => const Scaffold(
            backgroundColor: backgroundColor,
            body: RahaLoadingWidget(),
          ),
          error: (e, _) => Scaffold(
            backgroundColor: backgroundColor,
            body: RahaErrorWidget(
              message: e is Failure ? e.message : 'Something went wrong',
              onRetry: () => ref.invalidate(provider),
            ),
          ),
          data: (item) {
            final bool isCleaning =
                item.category.toLowerCase().contains('clean') ||
                item.name.toLowerCase().contains('maid');

            return Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
                children: [
                  // --- CANVAS SCROLL VIEW AREA ---
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // --- HERO PHOTO APP BAR ---
                        SliverAppBar(
                          expandedHeight: 240,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: primaryColor,
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.4,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                onPressed: () => context.pop(),
                              ),
                            ),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (item.photos.isNotEmpty)
                                  Image.network(
                                    item.photos.first,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  Container(
                                    color: primaryColor,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      isCleaning
                                          ? Icons.cleaning_services_rounded
                                          : Icons.handyman_rounded,
                                      size: 64,
                                      color: mintBgColor,
                                    ),
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.3),
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // --- CONTENT BLOCKS CANVAS ---
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name Title Header
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Category Subtitle
                                Text(
                                  item.category,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // --- HORIZONTAL PILL TAGS ROW ---
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildPillTag(
                                      icon: Icons.star_rounded,
                                      label:
                                          '${item.rating.toStringAsFixed(1)} Rating',
                                      color: textColor,
                                      bgColor: cardColor,
                                      hasBorder: true,
                                    ),
                                    if (item.priceRange.isNotEmpty)
                                      _buildPillTag(
                                        icon: Icons.payments_outlined,
                                        label: item.priceRange,
                                        color: goldColor,
                                        bgColor: const Color(0xFFFEF3E2),
                                      ),
                                    if (item.isVerified)
                                      _buildPillTag(
                                        icon: Icons.verified_user_rounded,
                                        label: 'Verified Partner',
                                        color: primaryColor,
                                        bgColor: mintBgColor,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // --- PROVIDER BIO BLOCK ---
                                if (item.bio.isNotEmpty) ...[
                                  const Text(
                                    'ABOUT PROVIDER',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.bio,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: textColor,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],

                                // --- REFINED LOCATION & CONTACT MATRICES CARD ---
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: borderColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildInfoRow(
                                        Icons.location_city_outlined,
                                        'Service Area',
                                        item.city,
                                      ),
                                      if (item.contactPhone.isNotEmpty) ...[
                                        const Divider(
                                          color: borderColor,
                                          height: 1,
                                        ),
                                        _buildInfoRow(
                                          Icons.phone_outlined,
                                          'Contact Number',
                                          item.contactPhone,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- PERSISTENT FLOATING BOTTOM BOOKING BAR ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      border: const Border(
                        top: BorderSide(color: borderColor, width: 0.5),
                      ),
                    ),
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BookingSheet(provider: item),
                        ),
                        child: const Text(
                          'Book this provider',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }

  Widget _buildPillTag({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    bool hasBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder ? Border.all(color: borderColor, width: 0.8) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: mutedColor),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: mutedColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
