import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/ui/theme/colors.dart';

class HeaderCard extends StatelessWidget {
  final String username;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;
  final int notificationsCount; // <-- nuevo parámetro

  const HeaderCard({
    super.key,
    required this.username,
    required this.onNotifications,
    required this.onLogout,
    this.notificationsCount = 0, // valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 20,
        20,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: Notificaciones y logout
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotifications,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.card,
                      size: 26,
                    ),
                  ),
                  if (notificationsCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            notificationsCount.toString(),
                            style: const TextStyle(
                              color: AppColors.card,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: onLogout,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ROW: Avatar y texto
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.card,
                child: Icon(Icons.person,
                    size: 28, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                      color: AppColors.card,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
