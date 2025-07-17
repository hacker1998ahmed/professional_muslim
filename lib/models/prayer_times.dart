class PrayerTime {
  final String name;
  final DateTime time;
  String adhanAudioPath;
  String notificationAudioPath;
  bool notificationsEnabled;
  bool preAdhanNotificationEnabled;
  int preAdhanNotificationMinutes;

  PrayerTime({
    required this.name,
    required this.time,
    required this.adhanAudioPath,
    this.notificationAudioPath = 'assets/audio/notification.mp3',
    this.notificationsEnabled = true,
    this.preAdhanNotificationEnabled = true,
    this.preAdhanNotificationMinutes = 15,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      adhanAudioPath: json['adhanAudioPath'] as String,
      notificationAudioPath: json['notificationAudioPath'] as String? ?? 'assets/audio/notification.mp3',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      preAdhanNotificationEnabled: json['preAdhanNotificationEnabled'] as bool? ?? true,
      preAdhanNotificationMinutes: json['preAdhanNotificationMinutes'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time.toIso8601String(),
      'adhanAudioPath': adhanAudioPath,
      'notificationAudioPath': notificationAudioPath,
      'notificationsEnabled': notificationsEnabled,
      'preAdhanNotificationEnabled': preAdhanNotificationEnabled,
      'preAdhanNotificationMinutes': preAdhanNotificationMinutes,
    };
  }
}

class LocationSettings {
  double latitude;
  double longitude;
  String city;
  String country;
  String calculationMethod;
  
  LocationSettings({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    this.calculationMethod = 'egyptian',
  });
  
  factory LocationSettings.fromJson(Map<String, dynamic> json) {
    return LocationSettings(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      city: json['city'] as String,
      country: json['country'] as String,
      calculationMethod: json['calculationMethod'] as String? ?? 'egyptian',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'calculationMethod': calculationMethod,
    };
  }
}

class AdhanSettings {
  bool adhanEnabled;
  bool vibrationEnabled;
  bool muteInSilentMode;
  double volume;
  List<String> availableAdhanSounds;
  List<String> availableNotificationSounds;
  
  AdhanSettings({
    this.adhanEnabled = true,
    this.vibrationEnabled = true,
    this.muteInSilentMode = false,
    this.volume = 0.7,
    this.availableAdhanSounds = const [
      'assets/audio/adhan.mp3',
      'assets/audio/adhan_makkah.mp3',
      'assets/audio/adhan_madinah.mp3',
    ],
    this.availableNotificationSounds = const [
      'assets/audio/notification.mp3',
      'assets/audio/notification_short.mp3',
    ],
  });
  
  factory AdhanSettings.fromJson(Map<String, dynamic> json) {
    return AdhanSettings(
      adhanEnabled: json['adhanEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      muteInSilentMode: json['muteInSilentMode'] as bool? ?? false,
      volume: json['volume'] as double? ?? 0.7,
      availableAdhanSounds: (json['availableAdhanSounds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? 
          ['assets/audio/adhan.mp3', 'assets/audio/adhan_makkah.mp3', 'assets/audio/adhan_madinah.mp3'],
      availableNotificationSounds: (json['availableNotificationSounds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? 
          ['assets/audio/notification.mp3', 'assets/audio/notification_short.mp3'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'adhanEnabled': adhanEnabled,
      'vibrationEnabled': vibrationEnabled,
      'muteInSilentMode': muteInSilentMode,
      'volume': volume,
      'availableAdhanSounds': availableAdhanSounds,
      'availableNotificationSounds': availableNotificationSounds,
    };
  }
}

class DailyPrayers {
  final DateTime date;
  final PrayerTime fajr;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  DailyPrayers({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory DailyPrayers.fromJson(Map<String, dynamic> json) {
    return DailyPrayers(
      date: DateTime.parse(json['date'] as String),
      fajr: PrayerTime.fromJson(json['fajr'] as Map<String, dynamic>),
      dhuhr: PrayerTime.fromJson(json['dhuhr'] as Map<String, dynamic>),
      asr: PrayerTime.fromJson(json['asr'] as Map<String, dynamic>),
      maghrib: PrayerTime.fromJson(json['maghrib'] as Map<String, dynamic>),
      isha: PrayerTime.fromJson(json['isha'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'fajr': fajr.toJson(),
      'dhuhr': dhuhr.toJson(),
      'asr': asr.toJson(),
      'maghrib': maghrib.toJson(),
      'isha': isha.toJson(),
    };
  }
  
  PrayerTime getCurrentPrayer() {
    final now = DateTime.now();
    final prayers = [fajr, dhuhr, asr, maghrib, isha];
    
    for (int i = prayers.length - 1; i >= 0; i--) {
      if (now.isAfter(prayers[i].time)) {
        return prayers[i];
      }
    }
    
    return prayers.last; // Default to isha if no current prayer
  }
  
  PrayerTime getNextPrayer() {
    final now = DateTime.now();
    final prayers = [fajr, dhuhr, asr, maghrib, isha];
    
    for (final prayer in prayers) {
      if (now.isBefore(prayer.time)) {
        return prayer;
      }
    }
    
    // If all prayers for today have passed, return tomorrow's Fajr
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return PrayerTime(
      name: 'الفجر (غدًا)',
      time: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, fajr.time.hour, fajr.time.minute),
      adhanAudioPath: fajr.adhanAudioPath,
    );
  }
}