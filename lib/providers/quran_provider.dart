import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_page.dart';

class QuranProvider with ChangeNotifier {
  List<QuranPage> _pages = [];
  List<QuranBookmark> _bookmarks = [];
  int _currentPage = 1;
  bool _isDarkMode = false;

  List<QuranPage> get pages => _pages;
  List<QuranBookmark> get bookmarks => _bookmarks;
  int get currentPage => _currentPage;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadQuranData() async {
    try {
      // محاولة تحميل البيانات من الملف
      final String response = await rootBundle.loadString('assets/data/quran_data.json');
      final data = await json.decode(response) as Map<String, dynamic>;

      if (data['pages'] != null) {
        _pages = (data['pages'] as List)
            .map((json) => QuranPage.fromJson(json))
            .toList();
      } else {
        // إنشاء بيانات تجريبية إذا لم توجد البيانات
        _pages = _createSamplePages();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading Quran data: $e');
      // إنشاء بيانات تجريبية في حالة الخطأ
      _pages = _createSamplePages();
      notifyListeners();
    }
  }

  List<QuranPage> _createSamplePages() {
    return List.generate(604, (index) {
      return QuranPage(
        pageNumber: index + 1,
        text: 'هذه صفحة تجريبية رقم ${index + 1} من القرآن الكريم. يجب استبدالها بالنص الفعلي للقرآن.',
        surahName: index < 50 ? 'الفاتحة' : 'البقرة',
        surahNumber: index < 50 ? 1 : 2,
        juz: ((index + 1) / 20).ceil(),
        hizb: ((index + 1) / 10).ceil(),
        rub: ((index + 1) / 5).ceil(),
      );
    });
  }



  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksJson = prefs.getString('quran_bookmarks');
    if (bookmarksJson != null) {
      final List<dynamic> bookmarksData = json.decode(bookmarksJson);
      _bookmarks = bookmarksData.map((json) => QuranBookmark.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String bookmarksJson = json.encode(_bookmarks.map((b) => b.toJson()).toList());
    await prefs.setString('quran_bookmarks', bookmarksJson);
  }

  void setCurrentPage(int page) {
    if (page >= 1 && page <= _pages.length) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void addBookmark(QuranBookmark bookmark) {
    _bookmarks.add(bookmark);
    saveBookmarks();
    notifyListeners();
  }

  void removeBookmark(int pageNumber) {
    _bookmarks.removeWhere((b) => b.pageNumber == pageNumber);
    saveBookmarks();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  QuranPage? getPage(int pageNumber) {
    try {
      return _pages.firstWhere((page) => page.pageNumber == pageNumber);
    } catch (e) {
      return null;
    }
  }

  List<QuranPage> searchPages({required String query}) {
    return _pages.where((page) {
      final surahMatch = page.surahNumber.toString().contains(query);
      final pageMatch = page.pageNumber.toString().contains(query);
      final juzMatch = page.juz.toString().contains(query);
      return surahMatch || pageMatch || juzMatch;
    }).toList();
  }
}