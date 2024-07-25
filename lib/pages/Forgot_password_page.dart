import 'package:cep_eczane/components/username_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void resetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre yenileme isteği e-postanıza gönderilmiştir.")),
      );
      Navigator.pop(context); 
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, 
        iconTheme: IconThemeData(color: Colors.black), 
        title: Text(
          "Şifremi Unuttum",
          style: TextStyle(color: Colors.black), 
        ),
      ),
      body: Container(
        color: Colors.white, 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            const SizedBox(height: 100),
            // Lock Icon
            Align(
              alignment: Alignment.topCenter, 
              child: Icon(
                Icons.lock,
                size: 80, 
                color: Colors.grey[700], 
              ),
            ),
            const SizedBox(height: 120),
            Text(
              "Şifre yenileme linki almak için mailinizi girin",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Mail Kutusu
            UsernameTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: resetPassword,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 99),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(206, 3, 45, 85),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          "Mail gönder",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
