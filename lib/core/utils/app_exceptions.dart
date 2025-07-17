// Custom Exceptions for Professional Muslim App

import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class LocationException extends AppException {
  const LocationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class StorageException extends AppException {
  const StorageException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class ValidationException extends AppException {
  const ValidationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class PermissionException extends AppException {
  const PermissionException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class DataException extends AppException {
  const DataException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class AuthException extends AppException {
  const AuthException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class TimeoutException extends AppException {
  const TimeoutException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class ParseException extends AppException {
  const ParseException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

// Exception Handler
class ExceptionHandler {
  static String getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'خطأ في الاتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى.';
    } else if (error is LocationException) {
      return 'خطأ في تحديد الموقع. تأكد من تفعيل خدمات الموقع.';
    } else if (error is StorageException) {
      return 'خطأ في حفظ البيانات. تحقق من مساحة التخزين المتاحة.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is PermissionException) {
      return 'لا توجد صلاحيات كافية. يرجى منح التطبيق الصلاحيات المطلوبة.';
    } else if (error is DataException) {
      return 'خطأ في تحميل البيانات. حاول مرة أخرى لاحقاً.';
    } else if (error is AuthException) {
      return 'خطأ في المصادقة. يرجى تسجيل الدخول مرة أخرى.';
    } else if (error is TimeoutException) {
      return 'انتهت مهلة الاتصال. حاول مرة أخرى.';
    } else if (error is ParseException) {
      return 'خطأ في معالجة البيانات. حاول مرة أخرى.';
    } else if (error is AppException) {
      return error.message;
    } else {
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }

  static String getErrorCode(dynamic error) {
    if (error is AppException) {
      return error.code ?? 'UNKNOWN_ERROR';
    }
    return 'UNKNOWN_ERROR';
  }

  static void logError(dynamic error, {StackTrace? stackTrace}) {
    // في التطبيق الحقيقي، يمكن إرسال الأخطاء لخدمة مراقبة مثل Firebase Crashlytics
    // استخدام debugPrint بدلاً من print للتطوير - يظهر فقط في وضع التطوير
    if (kDebugMode) {
      debugPrint('🔴 [ERROR] ${DateTime.now().toIso8601String()}: $error');
      if (stackTrace != null) {
        debugPrint('📍 [STACK TRACE]: $stackTrace');
      }
    }

    // يمكن إضافة المزيد من المعالجة هنا:
    // - إرسال للـ crash reporting service (Firebase Crashlytics)
    // - حفظ في ملف log محلي
    // - إرسال تقرير للمطور
    _handleErrorReporting(error, stackTrace);
  }

  // دالة مساعدة لمعالجة تقارير الأخطاء
  static void _handleErrorReporting(dynamic error, StackTrace? stackTrace) {
    // في وضع التطوير: عرض تفاصيل أكثر
    if (kDebugMode) {
      debugPrint('📝 [DEBUG LOG] Error Type: ${error.runtimeType}');
      debugPrint('📝 [DEBUG LOG] Error Details: ${error.toString()}');
    }

    // في الإنتاج: يمكن إرسال التقارير لخدمة مراقبة
    // مثال: FirebaseCrashlytics.instance.recordError(error, stackTrace);

    // يمكن أيضاً حفظ الأخطاء محلياً للمراجعة لاحقاً
    _saveErrorLocally(error, stackTrace);
  }

  // دالة لحفظ الأخطاء محلياً (يمكن تطويرها لاحقاً)
  static void _saveErrorLocally(dynamic error, StackTrace? stackTrace) {
    // يمكن تنفيذ هذا لاحقاً لحفظ الأخطاء في SharedPreferences أو ملف
    // للآن نكتفي بالـ debug logging
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('💾 [LOCAL LOG] [$timestamp] Saved error: ${error.toString()}');
    }
  }

  // دالة مساعدة لتسجيل معلومات عامة (ليس أخطاء)
  static void logInfo(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ [INFO] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  // دالة مساعدة لتسجيل تحذيرات
  static void logWarning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ [WARNING] ${DateTime.now().toIso8601String()}: $message');
    }
  }
}

// Result wrapper for handling success/error states
class Result<T> {
  final T? data;
  final AppException? error;
  final bool isSuccess;

  const Result.success(this.data)
      : error = null,
        isSuccess = true;

  const Result.error(this.error)
      : data = null,
        isSuccess = false;

  bool get isError => !isSuccess;
}

// Loading states
enum LoadingState {
  idle,
  loading,
  success,
  error,
}

// Network states
enum NetworkState {
  connected,
  disconnected,
  unknown,
}

// Permission states
enum PermissionState {
  granted,
  denied,
  permanentlyDenied,
  unknown,
}

// Location states
enum LocationState {
  enabled,
  disabled,
  unknown,
}

// Common error codes
class ErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String locationError = 'LOCATION_ERROR';
  static const String storageError = 'STORAGE_ERROR';
  static const String validationError = 'VALIDATION_ERROR';
  static const String permissionError = 'PERMISSION_ERROR';
  static const String dataError = 'DATA_ERROR';
  static const String authError = 'AUTH_ERROR';
  static const String timeoutError = 'TIMEOUT_ERROR';
  static const String parseError = 'PARSE_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';
}

// Success messages
class SuccessMessages {
  static const String dataLoaded = 'تم تحميل البيانات بنجاح';
  static const String dataSaved = 'تم حفظ البيانات بنجاح';
  static const String settingsUpdated = 'تم تحديث الإعدادات بنجاح';
  static const String notificationScheduled = 'تم جدولة التذكير بنجاح';
  static const String backupCreated = 'تم إنشاء نسخة احتياطية بنجاح';
  static const String backupRestored = 'تم استعادة النسخة الاحتياطية بنجاح';
  static const String dataExported = 'تم تصدير البيانات بنجاح';
  static const String dataImported = 'تم استيراد البيانات بنجاح';
  static const String locationUpdated = 'تم تحديث الموقع بنجاح';
  static const String prayerTimesUpdated = 'تم تحديث مواقيت الصلاة بنجاح';
}

// Warning messages
class WarningMessages {
  static const String lowStorage = 'مساحة التخزين منخفضة';
  static const String oldData = 'البيانات قديمة، يُنصح بالتحديث';
  static const String locationInaccurate = 'قد يكون الموقع غير دقيق';
  static const String networkSlow = 'الاتصال بالإنترنت بطيء';
  static const String batteryLow = 'البطارية منخفضة';
  static const String permissionLimited = 'بعض الميزات قد لا تعمل بدون الصلاحيات المطلوبة';
}

// Info messages
class InfoMessages {
  static const String firstTimeUser = 'مرحباً بك في تطبيق أذكار المسلم المحترف';
  static const String featureComingSoon = 'هذه الميزة ستكون متاحة قريباً';
  static const String updateAvailable = 'يتوفر تحديث جديد للتطبيق';
  static const String offlineMode = 'أنت تستخدم التطبيق في وضع عدم الاتصال';
  static const String dataSync = 'جاري مزامنة البيانات...';
  static const String locationDetected = 'تم تحديد موقعك تلقائياً';
}
