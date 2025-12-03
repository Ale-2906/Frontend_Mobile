import 'package:flutter/material.dart';
import '../../theme/colors.dart';


class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PasswordInput({
    super.key,
    required this.controller,
    this.label = "Contraseña",
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: obscure,
          decoration: InputDecoration(
          hintText: "••••••••",
          hintStyle: TextStyle(
            color: AppColors.placeholder, // 👈 placeholder clarito
            fontSize: 14,
          ),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => obscure = !obscure),
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) =>
              (v == null || v.length < 4) ? "Mínimo 4 caracteres" : null,
        ),
      ],
    );
  }
}
