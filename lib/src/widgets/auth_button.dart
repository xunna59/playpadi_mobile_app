import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        icon: Icon(icon, size: 22),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        onPressed: onPressed,
      ),
    );
  }
}
