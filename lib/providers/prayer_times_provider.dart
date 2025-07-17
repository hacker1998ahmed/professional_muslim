import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';

class PrayerTimesProvider extends ChangeNotifier {
  PrayerTimes? _prayerTimes;
  Position? _currentPosition;
  bool _isLoading = true;
  String _error = '';
  bool _isLocationEnabled = false;

  PrayerTimes? get prayerTimes => _prayerTimes;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLocationEnabled => _isLocationEnabled;

  // Simple prayer times structure
  Map<String, DateTime> get dailyPrayers {
    if (_prayerTimes == null) return {};
    
    return {
      'fajr': _prayerTimes!.fajr,
      'dhuhr': _prayerTimes!.dhuhr,
      'asr': _prayerTimes!.asr,
      'maghrib': _prayerTimes!.maghrib,
      'isha': _prayerTimes!.isha,
    };
  }

  PrayerTimesProvider() {
    updatePrayerTimes();
  }

  Future<void> updatePrayerTimes() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      // Get location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض صلاحيات الموقع');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('تم رفض صلاحيات الموقع نهائياً');
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Calculate prayer times
      final coordinates = Coordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;


      _prayerTimes = PrayerTimes.today(coordinates, params);

      _isLocationEnabled = true;
      _isLoading = false;
    } catch (e) {
      _error = 'حدث خطأ: ${e.toString()}';
      _isLoading = false;
      _isLocationEnabled = false;
    }
    notifyListeners();
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Get next prayer
  String getNextPrayer() {
    if (_prayerTimes == null) return '';
    
    final now = DateTime.now();
    final prayers = dailyPrayers;
    
    for (final entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry.key;
      }
    }
    
    return 'fajr'; // Next day's Fajr
  }

  // Get time until next prayer
  Duration? getTimeUntilNextPrayer() {
    if (_prayerTimes == null) return null;
    
    final now = DateTime.now();
    final prayers = dailyPrayers;
    
    for (final entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry.value.difference(now);
      }
    }
    
    // Next day's Fajr
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowCoordinates = Coordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    final params = CalculationMethod.egyptian.getParameters();
    final tomorrowPrayers = PrayerTimes(
      tomorrowCoordinates,
      DateComponents.from(tomorrow),
      params,
    );
    
    return tomorrowPrayers.fajr.difference(now);
  }
}
