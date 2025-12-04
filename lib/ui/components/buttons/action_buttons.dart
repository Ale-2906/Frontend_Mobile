import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/main.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onReceipt;

  const ActionButtons({super.key, required this.onShare, required this.onReceipt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share_outlined),
            label: const Text("Compartir"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReceipt,
            icon: const Icon(Icons.receipt_long),
            label: const Text("Recibo"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
