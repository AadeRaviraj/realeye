import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  LanguageProvider() {
    loadLocale(); // Load saved language when provider initializes
  }

  /// Get current locale (can be null = system default)
  Locale? get locale => _locale;

  /// Set and save selected locale
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    print("LanguageProvider: Locale set to ${locale.languageCode}");
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  /// Clear saved locale (will fallback to system default)
  Future<void> clearLocale() async {
    _locale = _locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('languageCode');
  }

  /// Load saved locale from SharedPreferences
  // Future<void> loadLocale() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final String? languageCode = prefs.getString('languageCode');
  //   //
  //   // if (languageCode != null && languageCode.isNotEmpty) {
  //   //   _locale = Locale(languageCode);
  //   //   notifyListeners();
  //   // }
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final String? languageCode = prefs.getString('languageCode');
  //     if (languageCode != null && languageCode.isNotEmpty) {
  //       _locale = Locale(languageCode);
  //       print("LanguageProvider: Loaded locale $languageCode from preferences");
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("LanguageProvider: Error loading locale: $e");
  //   }
  // }
  //
  //
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString('languageCode');
      if (languageCode != null && languageCode.isNotEmpty) {
        _locale = Locale(languageCode);
        print("Loaded locale: $languageCode");
        notifyListeners();
      }
    } catch (e) {
      print("Error loading locale: $e");
      _locale = const Locale('en'); // Fallback
    }
  }
}
