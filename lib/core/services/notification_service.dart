import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> scheduleClassReminder(int id, String className, String room, DateTime classTime) async {
    if (kIsWeb) return;
    final scheduleTime = classTime.subtract(const Duration(minutes: 15));
    if (scheduleTime.isBefore(DateTime.now())) return;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: 'Pengingat Kuliah: $className',
      body: 'Kelas akan dimulai dalam 15 menit di ruang $room. Yuk siap-siap!',
      scheduledDate: tz.TZDateTime.from(scheduleTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('class_reminder', 'Pengingat Kelas',
            channelDescription: 'Notifikasi untuk jadwal kuliah harian',
            importance: Importance.high,
            priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showInstantNotification(String title, String body) async {
    if (kIsWeb) return;
    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('general', 'General',
            importance: Importance.high,
            priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}