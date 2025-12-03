import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../buttons/primary_button.dart';

class SaleSuccessModal extends StatelessWidget {
  final Map<String, dynamic> sale;

  const SaleSuccessModal({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: AppColors.success, size: 60),
        const SizedBox(height: 12),
        Text("Venta Completada", style: AppTextStyles.title),
        const SizedBox(height: 4),
        Text("El stock se ha actualizado correctamente",
            style: AppTextStyles.subtitle),
        const SizedBox(height: 16),

        Text("ID: ${sale['id']}"),
        Text("Empleado: ${sale['employee']}"),

        const SizedBox(height: 24),
        PrimaryButton(
          text: "Nueva Venta",
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
