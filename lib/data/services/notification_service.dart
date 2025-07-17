import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz; // Removed to avoid dependency issues

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    // Permissions are handled during initialization
    debugPrint('Notification permissions requested');
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  // Show instant notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? sound,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
      sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
      playSound: sound != null,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Schedule notification (simplified without timezone)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String? sound,
  }) async {
    // For now, just show immediate notification
    // In a full implementation, you would use timezone package
    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      sound: sound,
    );
  }

  // Schedule daily notification (simplified)
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    String? sound,
  }) async {
    // For now, just show immediate notification
    // In a full implementation, you would use timezone package
    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      sound: sound,
    );
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Prayer time notifications
  Future<void> schedulePrayerNotifications(Map<String, DateTime> prayerTimes) async {
    // Cancel existing prayer notifications
    for (int i = 100; i < 106; i++) {
      await cancelNotification(i);
    }

    int notificationId = 100;
    final prayerNames = {
      'fajr': 'الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };

    for (final entry in prayerTimes.entries) {
      final prayerName = prayerNames[entry.key] ?? entry.key;
      
      await scheduleNotification(
        id: notificationId++,
        title: 'حان وقت صلاة $prayerName',
        body: 'حان الآن وقت صلاة $prayerName',
        scheduledTime: entry.value,
        payload: 'prayer_${entry.key}',
        sound: 'adhan',
      );
    }
  }

  // Azkar reminder notifications
  Future<void> scheduleAzkarReminders() async {
    // Morning azkar
    await scheduleDailyNotification(
      id: 200,
      title: 'أذكار الصباح',
      body: 'حان وقت أذكار الصباح',
      hour: 6,
      minute: 0,
      payload: 'azkar_morning',
    );

    // Evening azkar
    await scheduleDailyNotification(
      id: 201,
      title: 'أذكار المساء',
      body: 'حان وقت أذكار المساء',
      hour: 18,
      minute: 0,
      payload: 'azkar_evening',
    );

    // Sleep azkar
    await scheduleDailyNotification(
      id: 202,
      title: 'أذكار النوم',
      body: 'لا تنس أذكار النوم',
      hour: 22,
      minute: 0,
      payload: 'azkar_sleep',
    );
  }

  // Quran reading reminder
  Future<void> scheduleQuranReminder() async {
    await scheduleDailyNotification(
      id: 300,
      title: 'تذكير قراءة القرآن',
      body: 'حان وقت قراءة القرآن الكريم',
      hour: 20,
      minute: 0,
      payload: 'quran_reading',
    );
  }

  // Fasting reminder
  Future<void> scheduleFastingReminder(DateTime suhoorTime, DateTime iftarTime) async {
    // Suhoor reminder
    await scheduleNotification(
      id: 400,
      title: 'تذكير السحور',
      body: 'حان وقت السحور',
      scheduledTime: suhoorTime.subtract(const Duration(minutes: 30)),
      payload: 'suhoor_reminder',
    );

    // Iftar reminder
    await scheduleNotification(
      id: 401,
      title: 'تذكير الإفطار',
      body: 'حان وقت الإفطار',
      scheduledTime: iftarTime,
      payload: 'iftar_reminder',
    );
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidImplementation?.areNotificationsEnabled() ?? false;
  }

  // Open notification settings
  Future<void> openNotificationSettings() async {
    debugPrint('Opening notification settings');
    // This would typically open system notification settings
  }
}
