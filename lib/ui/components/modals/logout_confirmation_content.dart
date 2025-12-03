import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

class LogoutConfirmationContent extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutConfirmationContent({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirmar cierre de sesión",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "¿Seguro que deseas cerrar sesión?",
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 24),

        PrimaryButton(
          text: "Cerrar sesión",
          onPressed: onConfirm,
        ),

        const SizedBox(height: 12),

        SecondaryButton(
          text: "Cancelar",
          onPressed: onCancel,
        ),
      ],
    );
  }
}
