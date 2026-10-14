import 'package:shared_preferences/shared_preferences.dart';

/// Small, non-secret settings. The auth token never goes here.
class AppPreferences {
  AppPreferences(this._prefs);

  static const _languageCodeKey = 'language_code';

  final SharedPreferences _prefs;

  String? get languageCode => _prefs.getString(_languageCodeKey);

  Future<void> setLanguageCode(String? code) => code == null
      ? _prefs.remove(_languageCodeKey)
      : _prefs.setString(_languageCodeKey, code);
}
