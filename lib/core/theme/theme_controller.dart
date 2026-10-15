import 'package:flutter/material.dart';
import 'package:studify/core/storage/app_preferences.dart';

/// Holds the theme the user picked: light, dark, or the device's
/// (the default).
class ThemeController extends ChangeNotifier {
  ThemeController(this._preferences)
    : _mode =
          ThemeMode.values.asNameMap()[_preferences.themeMode] ??
          ThemeMode.system;

  final AppPreferences _preferences;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    await _preferences.setThemeMode(mode.name);
  }
}
