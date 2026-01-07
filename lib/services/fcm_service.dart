import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      await _initializeLocalNotifications();
      await requestPermission();
    } catch (e) {
      print('FCM initialization error: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);
  }

  Future<void> requestPermission() async {
    try {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);
      print('FCM permission granted');
    } catch (e) {
      print('Error requesting FCM permission: $e');
    }
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  Future<void> saveTokenToFirestore(String userId) async {
    try {
      final token = await getToken();
      if (token != null) {
        print('Saving FCM token for user: $userId');
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'fcmToken': token},
        );
        print('FCM token saved successfully');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  void setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.messageId}');
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        details,
      );
      print('Local notification shown');
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      print('Deleting FCM token');
      await _fcm.deleteToken();
      print('FCM token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  Future<bool> areNotificationsEnabled() async {
    final settings = await _fcm.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> scheduleDailyReminder({int hour = 8, int minute = 0}) async {
    try {
      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        'Daily Reminder',
        channelDescription: 'Daily reminder to create notes',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);

      await _localNotifications.zonedSchedule(
        0,
        'Good Morning! 🌅',
        'Yuk bikin catatan hari ini! 📝',
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('Daily reminder scheduled for $hour:$minute');
    } catch (e) {
      print('Error scheduling daily reminder: $e');
    }
  }

  Future<void> scheduleStreakReminder({int hour = 20, int minute = 0}) async {
    try {
      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        'streak_reminder',
        'Streak Reminder',
        channelDescription: 'Reminder to maintain your streak',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);

      await _localNotifications.zonedSchedule(
        1,
        'Jangan Putus Streak! 🔥',
        'Kamu belum bikin catatan hari ini. Yuk biar streak tetap jalan!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('Streak reminder scheduled for $hour:$minute');
    } catch (e) {
      print('Error scheduling streak reminder: $e');
    }
  }

  Future<void> cancelDailyReminder() async {
    await _localNotifications.cancel(0);
    print('Daily reminder cancelled');
  }

  Future<void> cancelStreakReminder() async {
    await _localNotifications.cancel(1);
    print('Streak reminder cancelled');
  }

  Future<void> showStreakAchievement(int streak) async {
    String message = '';
    if (streak == 7) {
      message = 'Mantap! 7 hari berturut-turut! 🎉';
    } else if (streak == 30) {
      message = 'Luar biasa! 1 bulan streak! 🏆';
    } else if (streak == 100) {
      message = 'LEGEND! 100 hari streak! 👑';
    } else {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'achievement',
      'Achievement',
      channelDescription: 'Streak achievement notifications',
      importance: Importance.max,
      priority: Priority.max,
    );
    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      999,
      'Achievement Unlocked! 🎊',
      message,
      details,
    );
  }
}
