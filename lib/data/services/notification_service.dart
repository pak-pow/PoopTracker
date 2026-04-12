import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize time zones so the alarm knows what "8:00 PM" actually means locally
    tz.initializeTimeZones();

    // 2. Setup Android settings (telling it to use your newly generated app icon)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin
          .requestExactAlarmsPermission(); // Also ask for exact alarm permission!
    }
  }

  // Schedule Daily Notification
  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    // Always cancel existing ones before scheduling a new one to prevent spam
    await cancelAllNotifications();

    // Figure out the exact date and time for the NEXT occurrence of this time
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If that time has already passed today, schedule it for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'daily_journal_reminders', // Internal ID
          'Daily Reminders', // Channel Name shown in Android Settings
          channelDescription: 'Reminds you to log your daily entry',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Schedule the repeating alarm!
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to check in! ✨', // The Notification Title
      'Take a moment to log your rhythm for today.', // The Notification Body
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Allows it to fire even if phone is sleeping
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents
          .time, // This is the magic line that makes it repeat every day!
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
