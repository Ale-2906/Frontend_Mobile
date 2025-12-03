import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.navy,
    fontFamily: 'Montserrat',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.navy,
      secondary: AppColors.navyDark,
    ),
  );
}
