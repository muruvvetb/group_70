import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/notification_service.dart';
import 'screens/ilac_alarm_sayfasi.dart';

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  final NotificationService notificationService = NotificationService();
  await notificationService.init();

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IlacAlarmSayfasi(notificationService: notificationService),
    );
  }
}
