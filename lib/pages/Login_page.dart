import 'package:cep_eczane/components/google_button.dart';
import 'package:cep_eczane/components/my_button.dart';
import 'package:cep_eczane/components/password_textfield.dart';
import 'package:cep_eczane/components/username_textfield.dart';
import 'package:cep_eczane/pages/forgot_password_page.dart';
import 'package:cep_eczane/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Implement your sign-in logic here
  void signUserIn() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // Handle error here
      print("Error: ${e.message}");
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  // Implement your Google login logic here
  void GoogleLogin() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      await AuthService().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      // Handle error here
      print("Error: ${e.message}");
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),

                // App Name
                const Text(
                  "Cep Eczanem",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // App Logo
                Image.asset(
                  'lib/images/logo.png',
                  width: 150,
                  height: 150,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Giriş yap",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Mail Kutusu
                UsernameTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                // Şifre kutusu
                PasswordTextField(
                  controller: passwordController,
                  hintText: "Şifre",
                ),

                const SizedBox(height: 15),

                // Giriş yap buton
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        text: "Giriş yap",
                        onTap: signUserIn,
                      ),

                const SizedBox(height: 10),

                // Şifreni mi unuttun
                GestureDetector(
                  onTap: navigateToForgotPassword, // Add the navigation function here
                  child: Text(
                    "Şifreni mi unuttun?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Hesabın yok mu kayıt ol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesabın yok mu?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Divider
                const SizedBox(
                  width: 300.0,
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                ),

                const SizedBox(height: 20),

                // Google ile giriş
                GoogleButton(
                  onTap: GoogleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
