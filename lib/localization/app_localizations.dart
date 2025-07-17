import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar', ''), // Arabic
    Locale('en', ''), // English
  ];

  // App Title
  String get appTitle => _localizedValues[locale.languageCode]!['app_title']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get azkar => _localizedValues[locale.languageCode]!['azkar']!;
  String get prayer => _localizedValues[locale.languageCode]!['prayer']!;
  String get more => _localizedValues[locale.languageCode]!['more']!;

  // Azkar Categories
  String get morningAzkar => _localizedValues[locale.languageCode]!['morning_azkar']!;
  String get eveningAzkar => _localizedValues[locale.languageCode]!['evening_azkar']!;
  String get sleepAzkar => _localizedValues[locale.languageCode]!['sleep_azkar']!;
  String get prayerAzkar => _localizedValues[locale.languageCode]!['prayer_azkar']!;

  // Features
  String get tasbih => _localizedValues[locale.languageCode]!['tasbih']!;
  String get prayerTimes => _localizedValues[locale.languageCode]!['prayer_times']!;
  String get qibla => _localizedValues[locale.languageCode]!['qibla']!;
  String get quranReading => _localizedValues[locale.languageCode]!['quran_reading']!;
  String get quranMemorization => _localizedValues[locale.languageCode]!['quran_memorization']!;
  String get zakatCalculator => _localizedValues[locale.languageCode]!['zakat_calculator']!;
  String get fastingTracker => _localizedValues[locale.languageCode]!['fasting_tracker']!;
  String get inheritanceCalculator => _localizedValues[locale.languageCode]!['inheritance_calculator']!;

  // Common
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;

  // Greetings
  String get goodMorning => _localizedValues[locale.languageCode]!['good_morning']!;
  String get goodEvening => _localizedValues[locale.languageCode]!['good_evening']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'app_title': 'أذكار المسلم',
      'home': 'الرئيسية',
      'azkar': 'الأذكار',
      'prayer': 'الصلاة',
      'more': 'المزيد',
      'morning_azkar': 'أذكار الصباح',
      'evening_azkar': 'أذكار المساء',
      'sleep_azkar': 'أذكار النوم',
      'prayer_azkar': 'أذكار الصلاة',
      'tasbih': 'السبحة الإلكترونية',
      'prayer_times': 'مواقيت الصلاة',
      'qibla': 'اتجاه القبلة',
      'quran_reading': 'قراءة القرآن',
      'quran_memorization': 'حفظ القرآن',
      'zakat_calculator': 'حاسبة الزكاة',
      'fasting_tracker': 'تتبع الصيام',
      'inheritance_calculator': 'حاسبة المواريث',
      'loading': 'جاري التحميل...',
      'error': 'حدث خطأ',
      'retry': 'إعادة المحاولة',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'settings': 'الإعدادات',
      'about': 'عن التطبيق',
      'good_morning': 'صباح الخير',
      'good_evening': 'مساء الخير',
      'welcome': 'أهلاً بك في تطبيق أذكار المسلم',
    },
    'en': {
      'app_title': 'Muslim Azkar',
      'home': 'Home',
      'azkar': 'Azkar',
      'prayer': 'Prayer',
      'more': 'More',
      'morning_azkar': 'Morning Azkar',
      'evening_azkar': 'Evening Azkar',
      'sleep_azkar': 'Sleep Azkar',
      'prayer_azkar': 'Prayer Azkar',
      'tasbih': 'Digital Tasbih',
      'prayer_times': 'Prayer Times',
      'qibla': 'Qibla Direction',
      'quran_reading': 'Quran Reading',
      'quran_memorization': 'Quran Memorization',
      'zakat_calculator': 'Zakat Calculator',
      'fasting_tracker': 'Fasting Tracker',
      'inheritance_calculator': 'Inheritance Calculator',
      'loading': 'Loading...',
      'error': 'An error occurred',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'settings': 'Settings',
      'about': 'About',
      'good_morning': 'Good Morning',
      'good_evening': 'Good Evening',
      'welcome': 'Welcome to Muslim Azkar App',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
