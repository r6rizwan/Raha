import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_service.dart';
import '../../shared/widgets/raha_card.dart';
import '../../shared/widgets/raha_loading_widget.dart';
import 'bookings_notifier.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Strict Corporate Design System Color Palette
  static const Color primaryColor = AppColors.primary;
  static const Color mintBgColor = AppColors.mint;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color whiteTextColor = AppColors.whiteText;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  int _selectedTab = 0; // 0 = Bookings, 1 = Settings

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;
    final bookingsAsync = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- TOP HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              color: primaryColor,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR RAHA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: goldColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: mintBgColor,
                              child: Text(
                                (user?.name.isNotEmpty == true)
                                    ? user!.name[0].toUpperCase()
                                    : 'R',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? 'Raha User',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: whiteTextColor,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        size: 14,
                                        color: mutedColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          user?.email ?? 'No email associated',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: mutedColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${user?.nationality ?? 'Expat'} · ${user?.city ?? 'Dubai'}',
                                    style: TextStyle(
                                      color: whiteTextColor.withValues(
                                        alpha: 0.65,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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

            // --- MAIN CONTENT AREA ---
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
                  children: [
                    // IDENTITY & STATS BLOCK
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      decoration: const BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // CUSTOM SEGMENTED TAB CONTROL
                          Container(
                            height: 48,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                _buildTabButton(0, 'My Bookings'),
                                _buildTabButton(1, 'Settings'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ), // Spacing before the tab content
                        ],
                      ),
                    ),

                    // TAB CONTENT
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _selectedTab == 0
                            ? _buildBookingsTab(bookingsAsync)
                            : _buildSettingsTab(),
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

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? primaryColor : mutedColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSettingsGroup('Account', [
          _buildSettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile Details',
            subtitle: 'Update your name, city, and nationality',
            onTap: () {
              context.push('/edit-profile');
            },
          ),
          _buildSettingsTile(
            icon: Icons.payment_rounded,
            title: 'Payment Methods',
            subtitle: 'Manage your saved cards',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment Methods coming soon!')),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.bookmark_border_rounded,
            title: 'Saved Locations',
            subtitle: 'Your favorite food spots',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved Locations coming soon!')),
              );
            },
          ),
        ]),
        const SizedBox(height: 24),
        _buildSettingsGroup('More', [
          _buildSettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get assistance with your account',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon!')),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            subtitle: 'Sign out of your account securely',
            isDestructive: true,
            onTap: () => ref.read(authServiceProvider).signOut(),
          ),
        ]),
      ],
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: mutedColor,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(
                    color: borderColor,
                    height: 1,
                    indent: 64,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.redAccent : textColor;
    final iconColor = isDestructive ? Colors.redAccent : primaryColor;
    final iconBg = isDestructive ? const Color(0xFFFFEBEB) : mintBgColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: mutedColor),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDestructive
                    ? Colors.redAccent.withValues(alpha: 0.5)
                    : mutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsTab(AsyncValue<dynamic> bookingsAsync) {
    return bookingsAsync.when(
      loading: () => const RahaLoadingWidget(),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load bookings',
              style: TextStyle(color: mutedColor),
            ),
            TextButton(
              onPressed: () => ref.invalidate(bookingNotifierProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: mintBgColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 32,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Bookings Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You haven\'t made any service appointments or reservations recently.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: mutedColor,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          physics: const BouncingScrollPhysics(),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];
            final statusColors = _getStatusTheme(b.status);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RahaCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.event_note_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.providerName.isNotEmpty
                                      ? b.providerName
                                      : 'Unknown Provider',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'EEE, d MMM yyyy · h:mm a',
                                  ).format(b.scheduledAt.toLocal()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: mutedColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColors['bg'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              b.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: statusColors['text'],
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (b.status == 'pending' || b.status == 'confirmed') ...[
                        const SizedBox(height: 16),
                        const Divider(color: borderColor, height: 1),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: cardColor,
                                title: const Text(
                                  'Cancel Booking?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                content: const Text(
                                  'Are you sure you want to cancel this appointment?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: mutedColor,
                                    height: 1.4,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      'Keep it',
                                      style: TextStyle(
                                        color: mutedColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'Yes, cancel',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref
                                  .read(bookingNotifierProvider.notifier)
                                  .cancelBooking(b.id);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Cancel booking',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, Color> _getStatusTheme(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return {'bg': const Color(0xFF2E7D52), 'text': Colors.white};
      case 'pending':
        return {'bg': const Color(0xFFFEF3E2), 'text': goldColor};
      case 'cancelled':
      case 'rejected':
        return {'bg': const Color(0xFFFFEBEB), 'text': Colors.redAccent};
      default:
        return {'bg': const Color(0xFFF0F4F8), 'text': textColor};
    }
  }
}
