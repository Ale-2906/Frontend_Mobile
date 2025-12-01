import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const InventSmartApp());
}

class InventSmartApp extends StatelessWidget {
  const InventSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.green,
          onPrimary: Colors.white,
          secondary: AppColors.navy,
          onSecondary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
          onBackground: AppColors.textPrimary,
          error: const Color(0xFFDC2626),
          onError: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 8,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.green, width: 1.6),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class AppColors { // <- mueve esto a su propio archivo si quieres
  static const background = Color(0xFFF4F6FB);
  static const surface    = Colors.white;
  static const border     = Color(0xFFE6EAF2);
  static const textPrimary   = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const navyDark   = Color(0xFF0F1B2D);
  static const navy       = Color(0xFF15243A);
  static const green      = Color(0xFF16A34A);
  static const greenSoft  = Color(0xFF19B46D);
  static const infoBg     = Color(0xFFEFF6FF);
  static const infoBorder = Color(0xFFD1E3FF);
}
