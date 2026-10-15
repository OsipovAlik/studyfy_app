import 'package:shared_preferences/shared_preferences.dart';

/// Small, non-secret settings. The auth token never goes here.
class AppPreferences {
  AppPreferences(this._prefs);

  static const _languageCodeKey = 'language_code';
  static const _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;

  String? get languageCode => _prefs.getString(_languageCodeKey);

  Future<void> setLanguageCode(String? code) => code == null
      ? _prefs.remove(_languageCodeKey)
      : _prefs.setString(_languageCodeKey, code);

  /// `system`, `light` or `dark`; `null` until the user picks one.
  String? get themeMode => _prefs.getString(_themeModeKey);

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);
}
