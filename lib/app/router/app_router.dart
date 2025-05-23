// lib/app/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/go_router_refresh_stream.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/notes/presentation/home_screen.dart';
import '../../core/widgets/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshNotifier(ref),
    redirect: (context, state) {
      final authValue = ref.read(authStateProvider);

      final isLoading = authValue.isLoading;
      final isLoggedIn = authValue.asData?.value != null;

      final location = state.uri.toString();
      final loggingIn = location == '/login' || location == '/signup';

      // 🔹 While loading, show splash screen
      if (isLoading) return state.uri.toString() == '/' ? null : '/';

      // 🔹 Redirect unauthenticated users to login
      if (!isLoggedIn && !loggingIn) return '/login';

      // 🔹 Redirect logged-in users away from login/signup
      if (isLoggedIn && loggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
    ],
  );
});
