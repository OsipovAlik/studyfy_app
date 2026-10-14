import 'package:go_router/go_router.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/forgot_password_screen.dart';
import 'package:studify/features/auth/login_screen.dart';
import 'package:studify/features/home/home_screen.dart';
import 'package:studify/features/onboarding/onboarding_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';

  /// Pages a signed-out user may see.
  static const Set<String> signedOut = {onboarding, login, forgotPassword};
}

GoRouter createRouter({required AuthController auth}) {
  return GoRouter(
    // Signed out, every launch starts with the onboarding.
    initialLocation: auth.isSignedIn ? AppRoutes.home : AppRoutes.onboarding,
    // Re-run [redirect] when the user signs in or out (including a
    // session ended by the server), so no screen needs to navigate.
    refreshListenable: auth,
    redirect: (context, state) {
      final isPublic = AppRoutes.signedOut.contains(state.matchedLocation);
      if (auth.isSignedIn) return isPublic ? AppRoutes.home : null;
      // Logging out mid-use goes to login, where the reason is shown.
      return isPublic ? null : AppRoutes.login;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(
          initialEmail: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
