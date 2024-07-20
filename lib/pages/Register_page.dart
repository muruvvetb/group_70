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
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isLoading = false;

    void signUserUp() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (passwordController.text == confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // Registration successful, navigate to another page or do something else
        } else {
          // Passwords don't match
          showErrorMessage("Passwords do not match");
        }
      } on FirebaseAuthException catch (e) {
        // Handle FirebaseAuth exceptions
        print("FirebaseAuth Error: ${e.message}");
        showErrorMessage("FirebaseAuth Error: ${e.message}");
      } catch (e) {
        // Handle other exceptions
        print("Error: $e");
        showErrorMessage("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    void showErrorMessage(String message) {
      // Implement your error message display logic here
      // For example, showing a dialog or updating a text field
      print("Error: $message");
      // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    void GoogleLogin() async {
      setState(() {
        isLoading = true;
      });

      try {
        await AuthService().signInWithGoogle();
        // Google sign-in successful, navigate to another page or do something else
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuth Error: ${e.message}");
        showErrorMessage("FirebaseAuth Error: ${e.message}");
      } catch (e) {
        print("Error: $e");
        showErrorMessage("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
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
                  const SizedBox(height: 20),

                  // Logo
                  Image.asset(
                    'lib/images/logo.png',
                    width: 300,
                    height: 300,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Kayıt ol",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Email TextField
                  UsernameTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Password TextField
                  PasswordTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                  ),

                  const SizedBox(height: 10),

                  // Confirm Password TextField
                  PasswordTextField(
                    controller: confirmPasswordController,
                    hintText: "Şifreyi Onayla",
                  ),

                  const SizedBox(height: 10),

                  // Register Button
                  isLoading
                      ? CircularProgressIndicator()
                      : MyButton(
                          text: "Kayıt ol",
                          onTap: signUserUp,
                        ),

                  const SizedBox(height: 10),

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

                  const SizedBox(height: 20),

                  // Divider
                  const SizedBox(
                    width: 300.0,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                  ),

                  const SizedBox(height: 20),

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