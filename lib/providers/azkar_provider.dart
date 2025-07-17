import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/azkar.dart';

class AzkarProvider extends ChangeNotifier {
  List<AzkarCategory> _categories = [];
  int _tasbihCount = 0;
  bool _isLoading = true;
  String _error = '';
  bool _hasInitialized = false;

  List<AzkarCategory> get categories => _categories;
  int get tasbihCount => _tasbihCount;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasInitialized => _hasInitialized;

  AzkarProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _loadTasbihCount();
    await loadAzkar();
  }

  Future<void> _loadTasbihCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _tasbihCount = prefs.getInt('tasbih_count') ?? 0;
    } catch (e) {
      debugPrint('Error loading tasbih count: $e');
      _tasbihCount = 0;
    }
  }

  Future<void> _saveTasbihCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tasbih_count', _tasbihCount);
    } catch (e) {
      debugPrint('Error saving tasbih count: $e');
    }
  }

  Future<void> loadAzkar() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final List<AzkarCategory> loadedCategories = [];

      // Load azkar files with better error handling
      final azkarFiles = [
        {'path': 'assets/data/morning_azkar.json', 'name': 'أذكار الصباح'},
        {'path': 'assets/data/evening_azkar.json', 'name': 'أذكار المساء'},
        {'path': 'assets/data/sleep_azkar.json', 'name': 'أذكار النوم'},
        {'path': 'assets/data/prayer_azkar.json', 'name': 'أذكار الصلاة'},
      ];

      for (final file in azkarFiles) {
        try {
          final data = await rootBundle.loadString(file['path']!);
          final jsonData = json.decode(data);
          final category = AzkarCategory.fromJson(jsonData);
          loadedCategories.add(category);
        } catch (e) {
          debugPrint('Error loading ${file['name']}: $e');
          // Continue loading other files even if one fails
        }
      }

      if (loadedCategories.isEmpty) {
        throw Exception('لم يتم تحميل أي من ملفات الأذكار');
      }

      _categories = loadedCategories;
      _isLoading = false;
      _hasInitialized = true;
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل الأذكار: ${e.toString()}';
      _isLoading = false;
      _hasInitialized = true;
      debugPrint('Error in loadAzkar: $e');
    }
    notifyListeners();
  }

  Future<void> incrementTasbih() async {
    _tasbihCount++;
    notifyListeners();
    await _saveTasbihCount();
  }

  Future<void> resetTasbih() async {
    _tasbihCount = 0;
    notifyListeners();
    await _saveTasbihCount();
  }

  // Method to retry loading azkar if failed
  Future<void> retryLoadAzkar() async {
    await loadAzkar();
  }

  // Method to get azkar by category index safely
  AzkarCategory? getCategoryByIndex(int index) {
    if (index >= 0 && index < _categories.length) {
      return _categories[index];
    }
    return null;
  }

  // Method to check if a specific category exists
  bool hasCategoryAtIndex(int index) {
    return index >= 0 && index < _categories.length;
  }
}