import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cep_eczane/main.dart' as main_app;
import 'package:cep_eczane/services/notification_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // NotificationService instance oluştur
    final NotificationService notificationService = NotificationService();
    await notificationService.init();

    // Build our app and trigger a frame.
    await tester
        .pumpWidget(main_app.MyApp(notificationService: notificationService));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
