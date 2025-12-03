import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class NavbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavbarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? AppColors.navy : Colors.grey),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: active ? AppColors.navy : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
