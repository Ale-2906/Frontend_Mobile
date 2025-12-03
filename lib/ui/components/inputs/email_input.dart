import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const EmailInput({
    super.key,
    required this.controller,
    this.label = "Correo Electrónico",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "empleado@negocio.com",
            hintStyle: TextStyle(
              color: AppColors.placeholder, // 👈 placeholder clarito
              fontSize: 14,
            ),
            prefixIcon: const Icon(Icons.mail_outline),
            filled: true,
            fillColor: AppColors.emailInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Ingrese su correo";
            final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v);
            return ok ? null : "Correo no válido";
          },
        ),
      ],
    );
  }
}
