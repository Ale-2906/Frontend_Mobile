import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/sales/sales_page.dart';
import 'package:inventsmart_mobile/pages/stock/stock_page.dart';
import 'navbar_item.dart';

class CustomNavbar extends StatelessWidget {
  final int current;
  final void Function(int) onChange;

  const CustomNavbar({
    super.key,
    required this.current,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavbarItem(
            icon: Icons.home,
            label: "Inicio",
            active: current == 0,
            onTap: () => onChange(0),
          ),
          NavbarItem(
            icon: Icons.point_of_sale,
            label: "Ventas",
            active: current == 1,
            onTap: () {
              onChange(1); // Activa el estado del navbar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalesPage(),
                ),
              ).then((_) => onChange(0)); // Al volver, vuelve a "Inicio"
            },
          ),
          NavbarItem(
            icon: Icons.inventory_2_outlined,
            label: "Stock",
            active: current == 2,
            onTap: () {
              onChange(2);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StockPage(),
                ),
              ).then((_) => onChange(0));
            },
          ),
        ],
      ),
    );
  }
}
