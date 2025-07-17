import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ar', '');
  late SharedPreferences _prefs;
  static const String _languageKey = 'selected_language';

  Locale get currentLocale => _currentLocale;
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final String? languageCode = _prefs.getString(_languageKey);
      if (languageCode != null) {
        _currentLocale = Locale(languageCode, '');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      _currentLocale = Locale(languageCode, '');
      await _prefs.setString(_languageKey, languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguageCode = _currentLocale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(newLanguageCode);
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  TextDirection get textDirection {
    return _currentLocale.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // Get current language name
  String get currentLanguageName => getLanguageName(_currentLocale.languageCode);
}
