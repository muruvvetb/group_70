import 'package:cep_eczane/components/google_button.dart';
import 'package:cep_eczane/components/my_button.dart';
import 'package:cep_eczane/components/password_textfield.dart';
import 'package:cep_eczane/components/username_textfield.dart';
import 'package:cep_eczane/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameSurnameController = TextEditingController();
  bool isLoading = false;
  bool agreeToTerms = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameSurnameController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    if (!agreeToTerms) {
      showErrorMessage("Okudum, kabul ediyorum'u işaretlemelisiniz");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        showErrorMessage("Passwords do not match");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage("FirebaseAuth Error: ${e.message}");
    } catch (e) {
      showErrorMessage("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void GoogleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      showErrorMessage("Google Sign-In Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                const SizedBox(height: 0),

                // App Name & Logo
                Stack(
                  children: [
                    Image.asset(
                      'lib/images/logo.png',
                      width: 300,
                      height: 300,
                    ),
                    Positioned(
                      top: 70,
                      left: 70,
                      child: Text(
                        "Cep Eczanem", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 0),

                const Text(
                  "Kayıt ol",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Name and Surname TextField
                UsernameTextField(
                  controller: nameSurnameController,
                  hintText: "Ad - Soyad",
                  obscureText: false,
                ),

                const SizedBox(height: 5),

                // Email TextField
                UsernameTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 5),

                // Password TextField
                PasswordTextField(
                  controller: passwordController,
                  hintText: "Şifre",
                ),

                const SizedBox(height: 5),

                // Confirm Password TextField
                PasswordTextField(
                  controller: confirmPasswordController,
                  hintText: "Şifreyi Onayla",
                ),

                const SizedBox(height: 10),

                // Terms and Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "Üyelik sözleşmesini okudum, kabul ediyorum.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Register Button
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        text: "Kayıt ol",
                        onTap: signUserUp,
                      ),

                const SizedBox(height: 5),

                // Already have an account? Sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Çoktan hesabın var mı?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Giriş yap",
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Divider
                const SizedBox(
                  width: 300.0,
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                ),

                const SizedBox(height: 5),

                // Google Sign-In Button
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
