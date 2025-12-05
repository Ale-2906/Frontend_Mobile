import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/login_page.dart';
import 'package:inventsmart_mobile/pages/sales_page.dart';
import 'package:inventsmart_mobile/pages/stock/stock_page.dart';

// COMPONENTES
import '../ui/components/dashboard/header_card.dart';
import '../ui/components/dashboard/kpi_card.dart';
import '../ui/components/dashboard/product_item.dart';
import '../ui/components/buttons/primary_button.dart';
import '../ui/components/buttons/secondary_button.dart';
import '../ui/components/inputs/text_input.dart';
import '../ui/components/layout/screen_wrapper.dart';
import '../ui/components/layout/page_title.dart';
import '../ui/components/navbar/custom_navbar.dart';
import '../ui/components/modals/logout_confirmation_content.dart';
import '../ui/components/modals/confirmation_modal.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({
    super.key,
    required this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // 🔥 Mostrar modal de confirmación de logout
  void _showLogoutModal(BuildContext context) {
    showConfirmationModal(
      context: context,
      content: LogoutConfirmationContent(
        onConfirm: () {
          Navigator.pop(context); // Cerrar modal

          // Navegar al login eliminando historial
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        onCancel: () {
          Navigator.pop(context); // Cerrar modal
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  HeaderCard(
                    username: widget.userName,
                    onNotifications: () {},
                    onLogout: () => _showLogoutModal(context),
                  ),

                  const SizedBox(height: 18),

                  // BUSCADOR
                  TextInput(
                    hint: "Buscar productos...",
                    controller: TextEditingController(),
                    suffix: const Icon(Icons.search, color: Colors.grey),
                  ),

                  const SizedBox(height: 18),

                  // KPI GRID
                  Row(
                    children: [
                      Expanded(
                        child: KpiCard(
                          icon: Icons.inventory_2_outlined,
                          iconColor: Colors.blue,
                          value: "8",
                          label: "Productos",
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: KpiCard(
                          icon: Icons.point_of_sale,
                          iconColor: Colors.green,
                          value: "3",
                          label: "Ventas Hoy",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: KpiCard(
                          icon: Icons.warning_amber_rounded,
                          iconColor: Colors.amber,
                          value: "2",
                          label: "Stock Bajo",
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: KpiCard(
                          icon: Icons.show_chart,
                          iconColor: Colors.purple,
                          value: "\$145.50",
                          label: "Total Hoy",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ACCIONES RÁPIDAS
                  const PageTitle(title: "Acciones Rápidas", size: 18),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: "Nueva Venta",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SalesPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
Expanded(
  child: SecondaryButton(
    text: "Ver Stock",
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StockPage(),
     ),
          );
        },
      ),
    ),
  ],
), // 

                  const SizedBox(height: 28),

                  // PRODUCTOS RECIENTES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      PageTitle(title: "Productos Recientes", size: 18),
                      Text(
                        "Ver todos",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const ProductItem(
                    name: 'Laptop HP 15"',
                    stock: "Stock: 12 unidades",
                    price: "\$450.00",
                  ),
                  const ProductItem(
                    name: 'Mouse Inalámbrico',
                    stock: "Stock: 34 unidades",
                    price: "\$14.99",
                  ),

                  const SizedBox(height: 80), // espacio para navbar
                ],
              ),
            ),
          ),

          // NAVBAR FIJA
          CustomNavbar(
            current: currentIndex,
            onChange: (i) => setState(() => currentIndex = i),
          ),
        ],
      ),
    );
  }
}
