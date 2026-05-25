import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  static const bookings = '/profile/bookings';
}

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final auth = ref.read(authStateProvider).value;
      final profile = ref.read(userProfileProvider);
      final loc = state.matchedLocation;
      if (auth == null) return loc == AppRoutes.login ? null : AppRoutes.login;
      if (loc == AppRoutes.login) return AppRoutes.home;
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
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (_, _, child) => _Shell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(path: AppRoutes.food, builder: (_, _) => const FoodScreen()),
          GoRoute(
            path: AppRoutes.services,
            builder: (_, _) => const ServicesScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => const ProfileScreen(),
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
  const _Shell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final index = switch (GoRouterState.of(context).matchedLocation) {
      AppRoutes.food => 1,
      AppRoutes.services => 2,
      AppRoutes.profile => 3,
      _ => 0,
    };
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(
          [
            AppRoutes.home,
            AppRoutes.food,
            AppRoutes.services,
            AppRoutes.profile,
          ][i],
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
