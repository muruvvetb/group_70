import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          print('notification payload: $payload');
        }
      },
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
    List<bool> days,
  ) async {
    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        final tz.TZDateTime scheduledNotificationDateTime =
            _nextInstanceOfDayAndTime(scheduledDate, i);

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id + i,
          title,
          body,
          scheduledNotificationDateTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              channelDescription: 'your_channel_description',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
        );
      }
    }
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(DateTime scheduledDate, int day) {
    tz.TZDateTime scheduledDateTime = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledDate.hour,
      scheduledDate.minute,
    );

    while (scheduledDateTime.weekday != day + 1) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    if (scheduledDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 7));
    }

    return scheduledDateTime;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
