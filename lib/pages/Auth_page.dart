import 'package:cep_eczane/screens/home_screen.dart';
import 'package:cep_eczane/screens/medicine_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cep_eczane/screens/ilac_alarm_sayfasi.dart';
import 'package:cep_eczane/services/notification_service.dart';
import 'login_or_register_page.dart';
import 'package:cep_eczane/widgets/bottom_navigation_bar.dart';
import 'package:cep_eczane/services/firestore_service.dart';
import 'package:cep_eczane/screens/guest_home_page.dart';

class AuthPage extends StatelessWidget {
  final NotificationService notificationService;
  final FirestoreService firestoreService;

  const AuthPage({
    super.key,
    required this.notificationService,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check for loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // User logged in
          if (snapshot.hasData) {
            if (snapshot.data!.isAnonymous) {
              return GuestHomePage();
            } else {
              return CustomBottomNavigationBar(
                notificationService: notificationService,
                firestoreService: firestoreService,
              );
            }
          }

          // User NOT logged in
          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}
