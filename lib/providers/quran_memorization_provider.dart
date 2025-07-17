import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_memorization.dart';

class QuranMemorizationProvider extends ChangeNotifier {
  List<Surah> _surahs = [];
  bool _isLoading = true;
  String _error = '';
  late SharedPreferences _prefs;
  static const String _storageKey = 'quran_memorization_data';

  List<Surah> get surahs => _surahs;
  bool get isLoading => _isLoading;
  String get error => _error;

  double get totalMemorizationProgress {
    if (_surahs.isEmpty) return 0.0;
    final totalProgress = _surahs.fold(
        0.0, (sum, surah) => sum + surah.memorizationProgress);
    return totalProgress / _surahs.length;
  }

  QuranMemorizationProvider() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await loadMemorizationData();
    } catch (e) {
      _error = 'حدث خطأ أثناء تهيئة البيانات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMemorizationData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String? storedData = _prefs.getString(_storageKey);
      if (storedData != null) {
        final List<dynamic> decodedData = json.decode(storedData);
        _surahs = decodedData
            .map((data) => Surah.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        // يمكن إضافة تهيئة البيانات الأولية هنا
        await _initializeQuranData();
      }

      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeQuranData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quran_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> surahsData = jsonData['surahs'];
      
      _surahs = surahsData
          .map((surahData) => Surah.fromJson(surahData as Map<String, dynamic>))
          .toList();

      await saveMemorizationData();
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل بيانات القرآن: $e';
    }
  }

  Future<void> saveMemorizationData() async {
    try {
      final String encodedData =
          json.encode(_surahs.map((surah) => surah.toJson()).toList());
      await _prefs.setString(_storageKey, encodedData);
    } catch (e) {
      _error = 'حدث خطأ أثناء حفظ البيانات: $e';
      notifyListeners();
    }
  }

  Future<void> updateAyahStatus(
    int surahNumber,
    int ayahNumber,
    MemorizationStatus status,
  ) async {
    final surahIndex = _surahs.indexWhere((s) => s.number == surahNumber);
    if (surahIndex != -1) {
      final surah = _surahs[surahIndex];
      final ayahIndex = surah.ayahs.indexWhere((a) => a.number == ayahNumber);

      if (ayahIndex != -1) {
        final updatedAyah = surah.ayahs[ayahIndex].copyWith(
          status: status,
          lastReviewed: DateTime.now(),
        );

        final updatedAyahs = List<Ayah>.from(surah.ayahs);
        updatedAyahs[ayahIndex] = updatedAyah;

        // حساب نسبة الحفظ الجديدة
        final memorizedCount = updatedAyahs
            .where((ayah) => ayah.status == MemorizationStatus.memorized)
            .length;
        final newProgress = (memorizedCount / surah.totalAyahs) * 100;

        final updatedSurah = surah.copyWith(
          ayahs: updatedAyahs,
          memorizationProgress: newProgress,
        );

        _surahs[surahIndex] = updatedSurah;
        await saveMemorizationData();
        notifyListeners();
      }
    }
  }

  Future<void> addReview(
    int surahNumber,
    int ayahNumber,
    ReviewRating rating, {
    String? notes,
  }) async {
    final surahIndex = _surahs.indexWhere((s) => s.number == surahNumber);
    if (surahIndex != -1) {
      final surah = _surahs[surahIndex];
      final ayahIndex = surah.ayahs.indexWhere((a) => a.number == ayahNumber);

      if (ayahIndex != -1) {
        final ayah = surah.ayahs[ayahIndex];
        final newReview = Review(
          date: DateTime.now(),
          rating: rating,
          notes: notes,
        );

        final updatedReviews = List<Review>.from(ayah.reviews)..add(newReview);
        final updatedAyah = ayah.copyWith(
          reviews: updatedReviews,
          lastReviewed: DateTime.now(),
        );

        final updatedAyahs = List<Ayah>.from(surah.ayahs);
        updatedAyahs[ayahIndex] = updatedAyah;

        final updatedSurah = surah.copyWith(ayahs: updatedAyahs);
        _surahs[surahIndex] = updatedSurah;

        await saveMemorizationData();
        notifyListeners();
      }
    }
  }

  List<Ayah> getDueForReview() {
    final now = DateTime.now();
    final dueAyahs = <Ayah>[];

    for (final surah in _surahs) {
      for (final ayah in surah.ayahs) {
        if (ayah.status == MemorizationStatus.memorized &&
            ayah.lastReviewed != null) {
          final daysSinceLastReview =
              now.difference(ayah.lastReviewed!).inDays;

          // تحديد ما إذا كانت الآية تحتاج إلى مراجعة
          // بناءً على آخر تقييم وعدد الأيام منذ آخر مراجعة
          if (_needsReview(ayah, daysSinceLastReview)) {
            dueAyahs.add(ayah);
          }
        }
      }
    }

    return dueAyahs;
  }

  bool _needsReview(Ayah ayah, int daysSinceLastReview) {
    if (ayah.reviews.isEmpty) return true;

    final lastReview = ayah.reviews.last;
    switch (lastReview.rating) {
      case ReviewRating.excellent:
        return daysSinceLastReview >= 30; // مراجعة كل شهر
      case ReviewRating.good:
        return daysSinceLastReview >= 14; // مراجعة كل أسبوعين
      case ReviewRating.fair:
        return daysSinceLastReview >= 7; // مراجعة كل أسبوع
      case ReviewRating.poor:
        return daysSinceLastReview >= 3; // مراجعة كل 3 أيام
      case ReviewRating.needsPractice:
        return daysSinceLastReview >= 1; // مراجعة يومية
      default:
        return true;
    }
  }

  List<Surah> getRecommendedForMemorization() {
    return _surahs
        .where((surah) =>
            surah.memorizationProgress > 0 &&
            surah.memorizationProgress < 100)
        .toList()
      ..sort((a, b) => b.memorizationProgress.compareTo(a.memorizationProgress));
  }
}