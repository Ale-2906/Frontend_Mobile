import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class IconButtonRound extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const IconButtonRound({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: AppColors.navy,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
