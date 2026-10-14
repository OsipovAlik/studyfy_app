abstract final class AppConfig {
  /// Override with `--dart-define=API_BASE_URL=...` for staging or local.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://studyfy.api.frenchwithlea.am/api/v1',
  );
}
