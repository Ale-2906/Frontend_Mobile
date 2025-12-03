  import 'package:flutter/material.dart';
import '../../theme/colors.dart';
class CheckCircle extends StatelessWidget {
  const CheckCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 42,
      backgroundColor: AppColors.confirmacionVenta,
      child: Icon(Icons.check, size: 50, color:AppColors.success),
    );
  }
}
