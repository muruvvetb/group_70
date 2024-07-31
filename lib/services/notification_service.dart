import 'package:cep_eczane/services/notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  // The singleton instance
  static final NotificationService _instance = NotificationService._internal();
  static final NotificationHelper _notificationHelper = NotificationHelper();
  // Private constructor
  NotificationService._internal();

  // Factory constructor to return the same instance
  factory NotificationService() {
    return _instance;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    DateTime now = DateTime.now();
    String ilac_adi = notificationResponse.payload.toString();
    final String notificationDetails = now.toString() +
        " tarihinde " +
        ilac_adi +
        " ilacinizi almaniz gerekmektedir";

    print(notificationDetails);
    await _notificationHelper.addNotification(notificationDetails);
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Your channel ID
      'your_channel_name', // Your channel name
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
    String payload,
  ) async {
    final tz.TZDateTime scheduledDateTime =
        tz.TZDateTime.from(scheduledDate, tz.local);

    // Check if the scheduled date is in the future
    if (scheduledDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      throw ArgumentError('scheduledDate must be a date in the future');
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Your channel ID
      'your_channel_name', // Your channel name
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
