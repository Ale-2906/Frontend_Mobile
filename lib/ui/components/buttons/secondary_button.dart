import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon; // Nuevo parámetro opcional

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon, // opcional
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.navy, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.navy, size: 18),
                  const SizedBox(width: 6),
                  Text(text, style: const TextStyle(color: AppColors.navy)),
                ],
              )
            : Text(text, style: const TextStyle(color: AppColors.navy)),
      ),
    );
  }
}
