import 'package:cep_eczane/screens/home_screen.dart';
import 'package:cep_eczane/screens/medicine_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cep_eczane/screens/ilac_alarm_sayfasi.dart';
import 'package:cep_eczane/services/notification_service.dart';
import 'login_or_register_page.dart';
import 'package:cep_eczane/widgets/bottom_navigation_bar.dart';
import 'package:cep_eczane/services/firestore_service.dart'; // FirestoreService import edildi

class AuthPage extends StatelessWidget {
  final NotificationService notificationService;
  final FirestoreService
      firestoreService; // FirestoreService parametresi eklendi

  const AuthPage(
      {super.key,
      required this.notificationService,
      required this.firestoreService}); // FirestoreService parametresi eklendi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return CustomBottomNavigationBar(
              notificationService: notificationService,
              firestoreService:
                  firestoreService, // FirestoreService parametresi eklendi
            );
          }
          // user NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
