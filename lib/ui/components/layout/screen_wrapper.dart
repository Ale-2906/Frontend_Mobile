import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;     // 👈 NUEVO
  final Widget? bottomNavigationBar;     // 👈 (opcional por si luego lo usas)

  const ScreenWrapper({
    super.key,
    required this.child,
    this.appBar,                        // 👈 NUEVO
    this.bottomNavigationBar,           // 👈 opcional
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,                    // 👈 NUEVO
      bottomNavigationBar: bottomNavigationBar, // 👈 opcional
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
