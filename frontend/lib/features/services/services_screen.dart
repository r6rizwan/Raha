import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/service_categories.dart';
import '../../core/errors/failures.dart';
import '../../data/models/paginated_providers_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_empty_widget.dart';
import '../../shared/widgets/raha_error_widget.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'services_notifier.dart';
import '../../core/theme/app_theme.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  // Strict Corporate Design System Color Palette
  static const Color primaryColor = AppColors.primary;
  static const Color mintBgColor = AppColors.mint;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  String? category;
  bool _searchActive = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchQuery = '';
        _searchController.clear();
      } else {
        _searchFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;
    final filter = ServiceFilter(
      city: user?.city ?? 'Dubai',
      category: category,
    );
    final provider = serviceNotifierProvider(filter);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _searchActive
                            ? TextField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                autofocus: true,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search providers...',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white.withValues(alpha: 0.75),
                                    size: 20,
                                  ),
                                ),
                                onChanged: (v) => setState(
                                  () => _searchQuery = v.trim().toLowerCase(),
                                ),
                              )
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TRUSTED HELP',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: goldColor,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Home Services',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      IconButton(
                        onPressed: _toggleSearch,
                        icon: Icon(
                          _searchActive ? Icons.close_rounded : Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  if (!_searchActive) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Book verified providers around ${user?.city ?? 'Dubai'}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _searchActive ? 0 : 58,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _searchActive
                          ? const SizedBox.shrink()
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (final c in serviceCategories)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () =>
                                            category = category == c ? null : c,
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: category == c
                                              ? primaryColor
                                              : cardColor,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: category == c
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
                                            fontWeight: category == c
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: category == c
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
                            data: (data) {
                              final filtered = _searchQuery.isEmpty
                                  ? data.providers
                                  : data.providers.where((p) {
                                      return p.name.toLowerCase().contains(
                                            _searchQuery,
                                          ) ||
                                          p.category.toLowerCase().contains(
                                            _searchQuery,
                                          ) ||
                                          p.bio.toLowerCase().contains(
                                            _searchQuery,
                                          );
                                    }).toList();

                              if (filtered.isEmpty) {
                                return _searchQuery.isNotEmpty
                                    ? RahaEmptyWidget(
                                        message: 'No results for "$_searchQuery"',
                                      )
                                    : _CityExpandingEmptyState(
                                        city: user?.city ?? 'your city',
                                        type: 'home services',
                                      );
                              }

                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  13,
                                  4,
                                  13,
                                  24,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final p = filtered[index];
                                  final bool isCleaning =
                                      p.category.toLowerCase().contains(
                                        'clean',
                                      ) ||
                                      p.name.toLowerCase().contains('maid');
                                  final Color featureBg = isCleaning
                                      ? mintBgColor
                                      : const Color(0xFFFEF3E2);
                                  final Color iconColor = isCleaning
                                      ? primaryColor
                                      : goldColor;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: RahaCard(
                                      onTap: () =>
                                          context.push('/services/${p.id}'),
                                      child: Padding(
                                        padding: const EdgeInsets.all(11),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                color: featureBg,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: p.photos.isNotEmpty
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                          p.photos.first,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : null,
                                              ),
                                              alignment: Alignment.center,
                                              child: p.photos.isEmpty
                                                  ? Icon(
                                                      isCleaning
                                                          ? Icons
                                                                .cleaning_services_rounded
                                                          : Icons
                                                                .handyman_rounded,
                                                      color: iconColor,
                                                      size: 20,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _searchQuery.isNotEmpty
                                                      ? _buildHighlightedText(
                                                          p.name,
                                                          _searchQuery,
                                                        )
                                                      : Text(
                                                          p.name,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    textColor,
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        p.category,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: mutedColor,
                                                        ),
                                                      ),
                                                      const Text(
                                                        '  ·  ',
                                                        style: TextStyle(
                                                          color: mutedColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        p.priceRange.isNotEmpty
                                                            ? p.priceRange
                                                            : '\$\$',
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: goldColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '★ ${p.rating.toStringAsFixed(1)}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: p.isVerified
                                                        ? mintBgColor
                                                        : const Color(
                                                            0xFFF5F0E8,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    p.isVerified
                                                        ? 'Verified'
                                                        : 'Available',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: p.isVerified
                                                          ? primaryColor
                                                          : mutedColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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

  /// Renders provider name with the matching search query highlighted in gold.
  Widget _buildHighlightedText(String text, String query) {
    final lower = text.toLowerCase();
    final start = lower.indexOf(query);
    if (start == -1) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final end = start + query.length;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        children: [
          if (start > 0) TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: const TextStyle(
              color: goldColor,
              backgroundColor: Color(0xFFFEF3E2),
            ),
          ),
          if (end < text.length) TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }
}

/// Shown when a city has no data yet — city-aware friendly message.
class _CityExpandingEmptyState extends StatelessWidget {
  const _CityExpandingEmptyState({required this.city, required this.type});
  final String city;
  final String type;

  @override
  Widget build(BuildContext context) {
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
              'Coming to $city soon',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C2433),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We're expanding our $type to $city. Check back soon — we add new cities regularly!",
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
