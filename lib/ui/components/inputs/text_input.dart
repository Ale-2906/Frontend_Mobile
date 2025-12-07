import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Widget? suffix;
  final bool obscure;
  final ValueChanged<String>? onChanged; // <-- agregado

  const TextInput({
    super.key,
    required this.hint,
    required this.controller,
    this.suffix,
    this.obscure = false,
    this.onChanged, // <-- agregado al constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,     // <-- dispara cuando el usuario escribe
      onFieldSubmitted: onChanged, // <-- dispara al presionar Enter
    );
  }
}
