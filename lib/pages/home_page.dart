import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/login_page.dart';
import 'package:inventsmart_mobile/pages/sales_page.dart';
import '../main.dart'; // Para AppColors

/// ===================
///  DASHBOARD (Mock)
/// ===================
class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  // ----- DATOS ESTÁTICOS (MOCK) -----
  // ----- DATOS ESTÁTICOS (MOCK) -----
  final _kpis = const [
    _Kpi(
        title: 'Productos',
        value: '8',
        icon: Icons.inventory_2_rounded,
        color: Color(0xFF0EA5E9)), // azul
    _Kpi(
        title: 'Ventas Hoy',
        value: '3',
        icon: Icons.point_of_sale_rounded,
        color: Color(0xFF22C55E)), // verde
    _Kpi(
        title: 'Stock Bajo',
        value: '2',
        icon: Icons.warning_amber_rounded,
        color: Color(0xFFFACC15)), // amarillo
    _Kpi(
        title: 'Total Hoy',
        value: r'$145.50',
        icon: Icons.show_chart_rounded,
        color: Color(0xFF8B5CF6)), // morado
  ];

  final _recentProducts = const [
    _Product(name: 'Laptop HP 15"', stock: 12, price: 450.00),
    _Product(name: 'Mouse Inalámbrico', stock: 34, price: 14.99),
    _Product(name: 'Teclado Mecánico', stock: 8, price: 59.90),
  ];

  final _recentSales = const [
    _Sale(code: '#V-1023', customer: 'Carlos Ruiz', total: 85.50),
    _Sale(code: '#V-1022', customer: 'María P.', total: 42.00),
    _Sale(code: '#V-1021', customer: 'Evelyn L.', total: 18.00),
  ];

  final _lowStock = const [
    _Product(name: 'Cargador USB-C 30W', stock: 3, price: 19.90),
    _Product(name: 'Audífonos In-Ear', stock: 2, price: 12.50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _BottomNavBar(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _HeaderCardDark(
                userName: widget.userName,
                notificationCount: 2, // 🔔 Cambia el número si quieres probar
                onLogout: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
              ),
            ),

            // KPIs
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _kpis
                      .map((k) => _KpiCard(
                            title: k.title,
                            value: k.value,
                            icon: k.icon,
                            color: k.color,
                          ))
                      .toList(),
                ),
              ),
            ),

            // Acciones rápidas
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Acciones Rápidas'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: 'Nueva Venta',
                            icon: Icons.shopping_cart_outlined,
                            filled: true,
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => const SalesPage()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            label: 'Ver Stock',
                            icon: Icons.inventory_2_outlined,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Productos recientes
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _CardSection(
                  title: 'Productos Recientes',
                  onSeeAll: () {},
                  child: Column(
                    children: _recentProducts
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ProductTile(product: p),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),

            // Ventas recientes
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _CardSection(
                  title: 'Ventas Recientes',
                  onSeeAll: () {},
                  child: Column(
                    children: _recentSales
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _SaleTile(sale: s),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),

            // Stock crítico
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              sliver: SliverToBoxAdapter(
                child: _CardSection(
                  title: 'Stock Crítico',
                  onSeeAll: () {},
                  child: Column(
                    children: _lowStock
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ProductTile(product: p),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================
///  UI COMPONENTES
/// ===================

class _HeaderCardDark extends StatelessWidget {
  final String userName;
  final int notificationCount;
  final VoidCallback onLogout;

  const _HeaderCardDark({
    required this.userName,
    this.notificationCount = 0, // por defecto 0
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- FILA SUPERIOR ---
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(Icons.person, color: AppColors.navy),
              ),
              const SizedBox(width: 12),

              // --- TEXTO: BIENVENIDA + NOMBRE ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenido de vuelta',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              // --- ICONO: NOTIFICACIONES ---
              _IconBadge(
                icon: Icons.notifications_none_rounded,
                count: notificationCount,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        notificationCount > 0
                            ? 'Tienes $notificationCount notificaciones nuevas'
                            : 'No tienes notificaciones pendientes',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(width: 8),

              // --- ICONO: CERRAR SESIÓN ---
              _IconBadge(
                icon: Icons.logout_rounded,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content:
                          const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    onLogout(); // ← lo recibes desde HomePage: navega al Login y limpia sesión
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // --- BUSCADOR ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 48,
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2, // 2 por fila
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // === Ícono decorativo circular ===
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 12),

            // === Texto principal ===
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label,
      required this.icon,
      this.filled = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.navy : Colors.white;
    final fg = filled ? Colors.white : AppColors.textPrimary;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: filled
                    ? Colors.white.withOpacity(.15)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: filled ? Colors.white : AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final _Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text('Stock: ${product.stock} unidades',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text('\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  final _Sale sale;
  const _SaleTile({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_long_outlined,
                color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sale.code,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(sale.customer,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text('\$${sale.total.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final Widget child;
  const _CardSection({
    required this.title,
    required this.onSeeAll,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.textPrimary)),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: const Text('Ver todos',
                  style: TextStyle(color: AppColors.navy)),
            )
          ],
        ),
        child,
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final int? count;
  final VoidCallback onTap;
  const _IconBadge({required this.icon, this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        if (count != null && count! > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white),
              ),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNavBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.white,
      selectedIndex: index,
      onDestinationSelected: onChanged,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio'),
        NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Ventas'),
        NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stock'),
        NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alertas'),
      ],
    );
  }
}

/// ===================
///  MODELOS (Mock)
/// ===================
class _Kpi {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _Kpi({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _Product {
  final String name;
  final int stock;
  final double price;
  const _Product(
      {required this.name, required this.stock, required this.price});
}

class _Sale {
  final String code;
  final String customer;
  final double total;
  const _Sale(
      {required this.code, required this.customer, required this.total});
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary));
  }
}
