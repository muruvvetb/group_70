import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final Function()? onTap;

  const GoogleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15), // Reduced vertical padding
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black, width: 2), // Add black border
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/images/google.png', // Ensure this path is correct
                height: 24.0,
                width: 24.0,
              ),
              const SizedBox(width: 18), // Adjust the width for desired spacing
              const Text(
                "Google ile bağlan",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
