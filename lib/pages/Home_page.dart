import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User? user;

  HomePage({Key? key})
      : user = FirebaseAuth.instance.currentUser,
        super(key: key);

  // Sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Giriş yapıldı! " + (user?.email ?? ""),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
