import 'package:flutter/widgets.dart';
import 'package:studify/core/storage/app_preferences.dart';

/// A language the app ships with, with its name written in that language.
class AppLanguage {
  const AppLanguage(this.code, this.nativeName);

  final String code;
  final String nativeName;
}

/// Holds the language the user picked. `null` means "follow the device".
class LocaleController extends ChangeNotifier {
  LocaleController(this._preferences) {
    final saved = _preferences.languageCode;
    if (saved != null && languages.any((l) => l.code == saved)) {
      _locale = Locale(saved);
    }
  }

  /// Armenian first: it is the fallback when the device language
  /// is not supported, as on the website.
  static const languages = [
    AppLanguage('hy', 'Հայերեն'),
    AppLanguage('en', 'English'),
    AppLanguage('fr', 'Français'),
    AppLanguage('ru', 'Русский'),
  ];

  final AppPreferences _preferences;
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> setLanguage(String code) async {
    if (_locale?.languageCode == code) return;
    _locale = Locale(code);
    notifyListeners();
    await _preferences.setLanguageCode(code);
  }
}
