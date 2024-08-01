import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  final TextEditingController controller; // Specify the type
  final String hintText;
  final bool obscureText;

  const UsernameTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0), // Keep this const
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: Color(0xFFF6F6F6),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])
        ),
      ),
    );
  }
}
