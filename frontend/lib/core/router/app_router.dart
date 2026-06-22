import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/providers.dart';
import '../../features/auth/login_screen.dart';
import '../../features/food/food_detail_screen.dart';
import '../../features/food/food_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/services/provider_detail_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/profile/edit_profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const food = '/food';
  static const foodDetail = '/food/:spotId';
  static const services = '/services';
  static const provider = '/services/:providerId';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const bookings = '/profile/bookings';
}

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      if (authState.isLoading) return AppRoutes.splash;

      final auth = authState.value;
      final profile = ref.read(userProfileProvider);
      final loc = state.matchedLocation;
      if (auth == null) return loc == AppRoutes.login ? null : AppRoutes.login;
      if (loc == AppRoutes.login || loc == AppRoutes.splash) return AppRoutes.home;
      if (profile.hasValue &&
          profile.value == null &&
          loc != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (profile.hasValue &&
          profile.value != null &&
          loc == AppRoutes.onboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => Scaffold(
          backgroundColor: AppColors.primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppColors.gold,
                    strokeWidth: 3.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => _Shell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.food, builder: (_, _) => const FoodScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.services, builder: (_, _) => const ServicesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.foodDetail,
        builder: (_, s) =>
            FoodDetailScreen(spotId: s.pathParameters['spotId']!),
      ),
      GoRoute(
        path: AppRoutes.provider,
        builder: (_, s) =>
            ProviderDetailScreen(providerId: s.pathParameters['providerId']!),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),
    ],
  ),
);

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
    ref.listen(userProfileProvider, (_, _) => notifyListeners());
  }
  final Ref ref;
}

class _Shell extends StatelessWidget {
  const _Shell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_rounded,        label: 'Home'),
    (icon: Icons.restaurant_rounded,  label: 'Food'),
    (icon: Icons.handyman_rounded,    label: 'Services'),
    (icon: Icons.person_rounded,      label: 'Profile'),
  ];

  static const _activeColor   = Color(0xFF1B5E4B);
  static const _inactiveColor = Color(0xFF4A4A4A);
  static const _pillColor     = Color(0x1F1B5E4B); // 12% opacity

  @override
  Widget build(BuildContext context) {
    final selectedIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final isActive = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => navigationShell.goBranch(
                    i,
                    initialLocation: i == selectedIndex,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? _pillColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          tab.icon,
                          size: 22,
                          color: isActive ? _activeColor : _inactiveColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? _activeColor : _inactiveColor,
                        ),
                        child: Text(tab.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
