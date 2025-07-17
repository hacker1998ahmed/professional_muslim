import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._internal();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // String operations
  Future<void> setString(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  // Integer operations
  Future<void> setInt(String key, int value) async {
    await _preferences!.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences!.getInt(key);
  }

  // Boolean operations
  Future<void> setBool(String key, bool value) async {
    await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  // Double operations
  Future<void> setDouble(String key, double value) async {
    await _preferences!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences!.getDouble(key);
  }

  // List operations
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences!.getStringList(key);
  }

  // Object operations (JSON)
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    await _preferences!.setString(key, jsonString);
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = _preferences!.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  // List of objects operations
  Future<void> setObjectList(String key, List<Map<String, dynamic>> value) async {
    final jsonString = json.encode(value);
    await _preferences!.setString(key, jsonString);
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    final jsonString = _preferences!.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Remove operations
  Future<void> remove(String key) async {
    await _preferences!.remove(key);
  }

  Future<void> clear() async {
    await _preferences!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _preferences!.getKeys();
  }

  // Reload preferences
  Future<void> reload() async {
    await _preferences!.reload();
  }
}

// Storage keys constants
class StorageKeys {
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String tasbihCount = 'tasbih_count';
  static const String azkarData = 'azkar_data';
  static const String quranBookmarks = 'quran_bookmarks';
  static const String quranProgress = 'quran_progress';
  static const String fastingData = 'fasting_data';
  static const String prayerSettings = 'prayer_settings';
  static const String zakatSettings = 'zakat_settings';
  static const String inheritanceData = 'inheritance_data';
  static const String userPreferences = 'user_preferences';
  static const String appSettings = 'app_settings';
  static const String lastBackupDate = 'last_backup_date';
  static const String firstLaunch = 'first_launch';
  static const String appVersion = 'app_version';
}
