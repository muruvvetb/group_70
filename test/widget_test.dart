import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cep_eczane/main.dart';
import 'package:cep_eczane/services/notification_service.dart';
import 'package:cep_eczane/services/firestore_service.dart'; // FirestoreService import edildi

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // NotificationService oluşturun
    final notificationService = NotificationService();

    // FirestoreService oluşturun
    final firestoreService = FirestoreService();

    // MyApp örneğini oluşturun ve notificationService ile firestoreService parametrelerini sağlayın
    await tester.pumpWidget(MyApp(
      notificationService: notificationService,
      firestoreService:
          firestoreService, // FirestoreService parametresi eklendi
    ));

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
