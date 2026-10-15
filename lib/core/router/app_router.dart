import 'package:go_router/go_router.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/forgot_password_screen.dart';
import 'package:studify/features/auth/login_screen.dart';
import 'package:studify/features/home/home_screen.dart';
import 'package:studify/features/legal/legal_screen.dart';
import 'package:studify/features/onboarding/onboarding_screen.dart';
import 'package:studify/features/profile/profile_screen.dart';
import 'package:studify/features/settings/settings_screen.dart';
import 'package:studify/features/shell/main_shell.dart';
import 'package:studify/features/shell/tab_screens.dart';
import 'package:studify/l10n/app_localizations.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';

  // The five tabs of the signed-in app.
  static const homeTab = '/home';
  static const subjects = '/subjects';
  static const sessions = '/sessions';
  static const homework = '/homework';
  static const profile = '/profile';

  // Opened from the Profile tab.
  static const settings = '/profile/settings';
  static const privacyPolicy = '/profile/privacy';
  static const termsOfUse = '/profile/terms';

  /// Where a signed-in user lands.
  static const String home = homeTab;

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
      // Each tab keeps its own navigation stack and state.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homeTab,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.subjects,
                builder: (context, state) => const SubjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sessions,
                builder: (context, state) => const SessionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homework,
                builder: (context, state) => const HomeworkScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => LegalScreen(
                      title: AppLocalizations.of(context).privacyPolicy,
                    ),
                  ),
                  GoRoute(
                    path: 'terms',
                    builder: (context, state) => LegalScreen(
                      title: AppLocalizations.of(context).termsOfUse,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
