import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for managing the app's locale.
// Allows dynamic language switching, automatically detects system language,
// and persists language preference to local storage.
class LocaleProvider with ChangeNotifier {
  late Locale _locale;
  bool _isInitialized = false;

  LocaleProvider() {
    _locale = const Locale('en');
  }

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;

  // Initialize locale from saved preferences or system locale
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString('locale_code');

      if (savedLocale != null) {
        _locale = Locale(savedLocale);
      } else {
        // Auto-detect system language using PlatformDispatcher
        final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
        final systemLocale = platformDispatcher.locale;
        _locale = _getSupportedLocale(systemLocale);
        // Save the detected locale
        await prefs.setString('locale_code', _locale.languageCode);
      }
    } catch (e) {
      _locale = const Locale('en');
    }
    _isInitialized = true;
    notifyListeners();
  }

  // Get supported locale or fallback to English
  Locale _getSupportedLocale(Locale locale) {
    const supportedCodes = ['en', 'ru', 'kk'];
    if (supportedCodes.contains(locale.languageCode)) {
      return Locale(locale.languageCode);
    }
    return const Locale('en');
  }

  // Set locale and save to preferences
  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('locale_code', locale.languageCode);
      } catch (e) {
        debugPrint('Error saving locale: $e');
      }
      notifyListeners();
    }
  }

  // Get list of supported locales
  List<Locale> getSupportedLocales() {
    return const [
      Locale('en'),
      Locale('ru'),
      Locale('kk'),
    ];
  }
}