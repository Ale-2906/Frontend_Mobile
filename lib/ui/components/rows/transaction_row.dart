import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class TransactionRow extends StatelessWidget {
  final String keyText;
  final String valueText;
  const TransactionRow({super.key, required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(keyText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(valueText, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}
