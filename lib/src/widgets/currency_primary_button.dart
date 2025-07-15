import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CurrencyPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisabled ? Colors.grey.shade300 : colorScheme.primary,
          foregroundColor: isDisabled ? Colors.black45 : colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
