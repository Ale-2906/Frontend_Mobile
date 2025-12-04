import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
static const subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const small = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}
