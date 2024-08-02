import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cep_eczane/pages/login_page.dart'; // Import the login page

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the first route in the stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F3C51),
        title: const Text("Guest Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome, Guest!", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Return to Login"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Text color
                backgroundColor: Colors.red, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
