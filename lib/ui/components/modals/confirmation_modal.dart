import 'package:flutter/material.dart';
import '../../theme/colors.dart';

Future showConfirmationModal({
  required BuildContext context,
  required Widget content,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: content,
    ),
  );
}
