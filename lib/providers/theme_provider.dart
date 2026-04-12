import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for managing the app's theme mode.
// Allows switching between light, dark, and system themes,
// and persists the preference to local storage.
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  bool get isInitialized => _isInitialized;

  // Initialize theme from saved preferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('theme_mode');

      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == 'ThemeMode.$savedTheme',
          orElse: () => ThemeMode.system,
        );
      } else {
        _themeMode = ThemeMode.system;
      }
    } catch (e) {
      _themeMode = ThemeMode.system;
    }
    _isInitialized = true;
    notifyListeners();
  }

  // Set theme mode and save to preferences
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'theme_mode',
          themeMode.toString().split('.').last,
        );
      } catch (e) {
        debugPrint('Error saving theme mode: $e');
      }
      notifyListeners();
    }
  }

  // Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}