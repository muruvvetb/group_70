import 'package:cep_eczane/pages/Auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  final NotificationService notificationService = NotificationService();
  await notificationService.init();

  // Request permissions
  await _requestPermissions();

  runApp(MyApp(notificationService: notificationService));
}

Future<void> _requestPermissions() async {
  // Request notification permission
  if (await Permission.notification.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  } else {
    // Handle the case when the user declines the permission
    // You can show a dialog or message explaining why the permission is needed
  }

  // Request location permission if needed
  if (await Permission.location.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  } else {
    // Handle the case when the user declines the permission
    // You can show a dialog or message explaining why the permission is needed
  }

  // Request exact alarm permission if needed
  if (await Permission.scheduleExactAlarm.request().isGranted) {
    // The permission was granted
  } else {
    // Handle the case when the user declines the permission
    // You can show a dialog or message explaining why the permission is needed
  }
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(notificationService: notificationService),
    );
  }
}
