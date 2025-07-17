// App Constants for Professional Muslim App

class AppConstants {
  // App Information
  static const String appName = 'Professional Muslim';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'تطبيق شامل للأذكار والعبادات الإسلامية';
  static const String appSlogan = 'رفيقك في رحلة الإيمان';
  
  // Developer Information
  static const String developerName = 'Ahmed Mostafa Ibrahim';
  static const String developerEmail = 'gogom8870@gmail.com';
  static const String developerPhone = '01225155329';
  
  // Shared Preferences Keys
  static const String keyTasbihCount = 'tasbih_count';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyQuranBookmarks = 'quran_bookmarks';
  static const String keyQuranProgress = 'quran_progress';
  static const String keyFastingData = 'fasting_data';
  static const String keyPrayerSettings = 'prayer_settings';
  
  // Prayer Times
  static const List<String> prayerNames = [
    'الفجر',
    'الظهر', 
    'العصر',
    'المغرب',
    'العشاء'
  ];
  
  static const List<String> prayerNamesEn = [
    'Fajr',
    'Dhuhr',
    'Asr', 
    'Maghrib',
    'Isha'
  ];
  
  // Quran Constants
  static const int totalSurahs = 114;
  static const int totalPages = 604;
  static const int totalJuz = 30;
  static const int totalHizb = 60;
  
  // Zakat Nisab Values (in grams)
  static const double goldNisab = 85.0;
  static const double silverNisab = 595.0;
  static const double zakatPercentage = 2.5;
  
  // Fasting Types
  static const List<String> fastingTypes = [
    'رمضان',
    'الاثنين والخميس',
    'الأيام البيض',
    'يوم عرفة',
    'يوم عاشوراء',
    'صيام تطوعي'
  ];
  
  // Colors
  static const int primaryColorValue = 0xFF2E7D32;
  static const int secondaryColorValue = 0xFF4CAF50;
  static const int accentColorValue = 0xFFFFD700;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Text Sizes
  static const double smallTextSize = 12.0;
  static const double normalTextSize = 14.0;
  static const double mediumTextSize = 16.0;
  static const double largeTextSize = 18.0;
  static const double extraLargeTextSize = 24.0;
  
  // Spacing
  static const double smallSpacing = 8.0;
  static const double normalSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  // Border Radius
  static const double smallRadius = 4.0;
  static const double normalRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double circularRadius = 50.0;
  
  // Asset Paths
  static const String assetsPath = 'assets';
  static const String imagesPath = '$assetsPath/images';
  static const String audioPath = '$assetsPath/audio';
  static const String dataPath = '$assetsPath/data';
  static const String fontsPath = '$assetsPath/fonts';

  // Azkar Categories
  static const List<String> azkarCategories = [
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار النوم',
    'أذكار الاستيقاظ',
    'أذكار الصلاة',
    'أذكار الطعام',
    'أذكار السفر',
    'أذكار الوضوء',
    'أذكار المسجد',
    'أذكار متنوعة',
  ];

  // Tasbih Options
  static const List<String> tasbihOptions = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'استغفر الله',
    'لا حول ولا قوة إلا بالله',
    'سبحان الله وبحمده',
    'سبحان الله العظيم',
    'اللهم صل على محمد',
    'رب اغفر لي',
  ];

  // Tasbih Counts
  static const List<int> tasbihCounts = [33, 99, 100, 1000];

  // Default Location (Cairo)
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
  static const String defaultCity = 'القاهرة';
  static const String defaultCountry = 'مصر';

  // Notification IDs
  static const int prayerNotificationId = 1000;
  static const int azkarNotificationId = 2000;
  static const int quranNotificationId = 3000;
  static const int fastingNotificationId = 4000;

  // API URLs
  static const String prayerTimesApi = 'https://api.aladhan.com/v1/timings';
  static const String qiblaApi = 'https://api.aladhan.com/v1/qibla';
  static const String hijriDateApi = 'https://api.aladhan.com/v1/gToH';

  // File Extensions
  static const String jsonExtension = '.json';
  static const String mp3Extension = '.mp3';
  static const String pngExtension = '.png';
  static const String jpgExtension = '.jpg';

  // Additional Asset Paths
  static const String audioAssetsPath = '$assetsPath/audio';
  static const String dataAssetsPath = '$assetsPath/data';
  
  // Audio Files
  static const String adhanAudio = '$audioAssetsPath/adhan.mp3';
  static const String notificationSound = '$audioAssetsPath/notification.mp3';
  static const String tasbihSound = '$audioAssetsPath/tasbih.mp3';

  // Data Files
  static const String azkarData = '$dataAssetsPath/azkar.json';
  static const String quranData = '$dataAssetsPath/quran.json';
  
  // URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportUrl = 'https://example.com/support';
  
  // Regular Expressions
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  
  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String locationError = 'خطأ في تحديد الموقع';
  static const String permissionError = 'لا توجد صلاحيات كافية';
  static const String dataError = 'خطأ في تحميل البيانات';
  static const String unknownError = 'حدث خطأ غير متوقع';
  
  // Success Messages
  static const String dataLoaded = 'تم تحميل البيانات بنجاح';
  static const String dataSaved = 'تم حفظ البيانات بنجاح';
  static const String settingsUpdated = 'تم تحديث الإعدادات بنجاح';
  
  // Default Values
  static const int defaultTasbihTarget = 33;
  static const String defaultLanguage = 'ar';
  static const bool defaultDarkMode = false;
  static const double defaultFontSize = 16.0;
  
  // App Limits
  static const int maxTasbihTarget = 9999;
  static const int maxBookmarks = 100;
  static const int maxFastingDays = 365;
  static const int maxAzkarCount = 1000;
  static const int maxBackupFiles = 5;
  
  // Islamic Constants
  static const List<String> allahNames = [
    'الله', 'الرحمن', 'الرحيم', 'الملك', 'القدوس',
    'السلام', 'المؤمن', 'المهيمن', 'العزيز', 'الجبار'
    // يمكن إضافة باقي الأسماء الحسنى
  ];
  
  static const List<String> duaAfterPrayer = [
    'أستغفر الله',
    'أستغفر الله', 
    'أستغفر الله',
    'اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام'
  ];
}
