import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> scheduleNotification(int id, String title, String timeString) async {
    try {
      // Parse the time string (expecting format like "HH:mm")
      final timeParts = timeString.split(':');
      if (timeParts.length != 2) {
        print('Invalid time format for $title: $timeString');
        return;
      }

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Get current date and create a DateTime with today's date and specified time
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, 
        now.year, 
        now.month, 
        now.day, 
        hour, 
        minute
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        'Routine Alert',
        '$title is scheduled now',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'routine_channel', 
            'Daily Routine Notifications',
            importance: Importance.max, 
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Notification scheduled for $title at $scheduledDate');
    } catch (e) {
      print('Error scheduling notification for $title: $e');
    }
  }

  // Optional: Method to cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Optional: Method to cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}