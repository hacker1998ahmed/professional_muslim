import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fasting_tracker.dart';

class FastingProvider extends ChangeNotifier {
  List<FastingMonth> _fastingMonths = [];
  bool _isLoading = true;
  String _error = '';
  late SharedPreferences _prefs;
  static const String _storageKey = 'fasting_data';

  List<FastingMonth> get fastingMonths => _fastingMonths;
  bool get isLoading => _isLoading;
  String get error => _error;

  FastingProvider() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await loadFastingData();
    } catch (e) {
      _error = 'حدث خطأ أثناء تهيئة البيانات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFastingData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String? storedData = _prefs.getString(_storageKey);
      if (storedData != null) {
        final List<dynamic> decodedData = json.decode(storedData);
        _fastingMonths = decodedData
            .map((data) => FastingMonth.fromJson(data as Map<String, dynamic>))
            .toList();
      }

      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveFastingData() async {
    try {
      final String encodedData =
          json.encode(_fastingMonths.map((month) => month.toJson()).toList());
      await _prefs.setString(_storageKey, encodedData);
    } catch (e) {
      _error = 'حدث خطأ أثناء حفظ البيانات: $e';
      notifyListeners();
    }
  }

  Future<void> addFastingMonth(FastingMonth month) async {
    _fastingMonths.add(month);
    await saveFastingData();
    notifyListeners();
  }

  Future<void> updateFastDay(FastingMonth month, FastDay day, bool completed,
      {String? notes}) async {
    try {
      final monthIndex = _fastingMonths.indexOf(month);
      if (monthIndex != -1) {
        final dayIndex = month.days.indexWhere(
            (d) => d.date.year == day.date.year &&
                   d.date.month == day.date.month &&
                   d.date.day == day.date.day);
        if (dayIndex != -1) {
          final updatedDay = day.copyWith(completed: completed, notes: notes);
          final updatedDays = List<FastDay>.from(month.days);
          updatedDays[dayIndex] = updatedDay;

          final updatedMonth = FastingMonth(
            name: month.name,
            year: month.year,
            days: updatedDays,
            type: month.type,
          );

          _fastingMonths[monthIndex] = updatedMonth;
          await saveFastingData();
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'حدث خطأ أثناء تحديث اليوم: $e';
      notifyListeners();
    }
  }

  Future<void> deleteFastingMonth(FastingMonth month) async {
    _fastingMonths.remove(month);
    await saveFastingData();
    notifyListeners();
  }

  List<FastingMonth> getMonthsByType(FastingType type) {
    return _fastingMonths.where((month) => month.type == type).toList();
  }

  FastingMonth? getCurrentRamadan() {
    final now = DateTime.now();
    try {
      return _fastingMonths.firstWhere(
        (month) =>
            month.type == FastingType.ramadan && month.year == now.year,
      );
    } catch (e) {
      // إنشاء شهر رمضان جديد إذا لم يوجد
      final ramadanMonth = createRamadanMonth(now.year);
      _fastingMonths.add(ramadanMonth);
      saveFastingData();
      return ramadanMonth;
    }
  }

  FastingMonth createRamadanMonth(int year) {
    // يمكن إضافة حساب تواريخ رمضان الفعلية باستخدام مكتبة تقويم هجري
    final List<FastDay> days = List.generate(
      30,
      (index) => FastDay(
        date: DateTime(year, 9, index + 1), // مثال بسيط
        completed: false,
      ),
    );

    return FastingMonth(
      name: 'رمضان $year',
      year: year,
      days: days,
      type: FastingType.ramadan,
    );
  }

  // إحصائيات الصيام
  Map<String, int> getFastingStatistics() {
    int totalDays = 0;
    int completedDays = 0;
    int ramadanDays = 0;
    int voluntaryDays = 0;

    for (final month in _fastingMonths) {
      totalDays += month.days.length;
      completedDays += month.completedDays;

      if (month.type == FastingType.ramadan) {
        ramadanDays += month.completedDays;
      } else {
        voluntaryDays += month.completedDays;
      }
    }

    return {
      'totalDays': totalDays,
      'completedDays': completedDays,
      'ramadanDays': ramadanDays,
      'voluntaryDays': voluntaryDays,
    };
  }

  // الحصول على أيام الصيام في الشهر الحالي
  List<FastDay> getCurrentMonthFasting() {
    final now = DateTime.now();
    final currentMonthFasting = <FastDay>[];

    for (final month in _fastingMonths) {
      for (final day in month.days) {
        if (day.date.year == now.year && day.date.month == now.month) {
          currentMonthFasting.add(day);
        }
      }
    }

    return currentMonthFasting;
  }
}