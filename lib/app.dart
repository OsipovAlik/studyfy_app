import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/l10n/locale_controller.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/storage/app_preferences.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/core/theme/theme_controller.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/contact/contact_repository.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/students/data/students_repository.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Long-lived services, created once at startup (see `main.dart`).
class AppDependencies {
  AppDependencies._({
    required this.preferences,
    required this.client,
    required this.authRepository,
    required this.auth,
  });

  /// Builds the services and restores a saved session, if any.
  static Future<AppDependencies> create({
    required AppPreferences preferences,
    required SessionStorage sessionStorage,
    ApiClient? client,
  }) async {
    final apiClient = client ?? ApiClient();
    final authRepository = AuthRepository(apiClient);
    final auth = AuthController(
      client: apiClient,
      repository: authRepository,
      storage: sessionStorage,
      restored: await sessionStorage.read(),
    );
    return AppDependencies._(
      preferences: preferences,
      client: apiClient,
      authRepository: authRepository,
      auth: auth,
    );
  }

  final AppPreferences preferences;
  final ApiClient client;
  final AuthRepository authRepository;
  final AuthController auth;
}

class StudyfyApp extends StatefulWidget {
  const StudyfyApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<StudyfyApp> createState() => _StudyfyAppState();
}

class _StudyfyAppState extends State<StudyfyApp> {
  late final GoRouter _router = createRouter(auth: widget.dependencies.auth);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.dependencies;
    return MultiProvider(
      providers: [
        Provider.value(value: deps.preferences),
        Provider.value(value: deps.client),
        Provider.value(value: deps.authRepository),
        ChangeNotifierProvider.value(value: deps.auth),
        ChangeNotifierProvider(
          create: (_) => LocaleController(deps.preferences),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController(deps.preferences),
        ),
        Provider(create: (_) => ContactRepository(deps.client)),
        Provider(create: (_) => SessionsRepository(deps.client)),
        Provider(create: (_) => StudentsRepository(deps.client)),
        ChangeNotifierProvider(
          create: (context) => TimetableController(
            repository: context.read<SessionsRepository>(),
            auth: deps.auth,
          ),
        ),
      ],
      child: Consumer2<LocaleController, ThemeController>(
        builder: (context, localeController, themeController, _) =>
            MaterialApp.router(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeController.mode,
              locale: localeController.locale,
              // Armenian first: the fallback when the device language is
              // not one of ours.
              supportedLocales: [
                for (final language in LocaleController.languages)
                  Locale(language.code),
              ],
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              routerConfig: _router,
            ),
      ),
    );
  }
}
