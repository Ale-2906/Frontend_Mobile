import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/sales_page.dart';
import 'package:inventsmart_mobile/pages/stock/stock_page.dart';
import 'navbar_item.dart';

class CustomNavbar extends StatelessWidget {
  final int current;
  final void Function(int) onChange;

  const CustomNavbar(
      {super.key, required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
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
              onChange(1); // Mantiene el estado activo del navbar

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalesPage(),
                ),
                ).then((_) {
               
                onChange(0);
              });
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
                ).then((_) {
    
                onChange(0);
              });
            },
          ),
        ],
      ),
    );
  }
}
