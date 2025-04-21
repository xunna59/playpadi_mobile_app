import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.onTap,
    this.backgroundColor = Colors.deepOrange,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: textColor)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: textColor),
          ],
        ),
      ),
    );
  }
}
