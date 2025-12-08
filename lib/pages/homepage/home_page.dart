import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/homepage/login_page.dart';
import 'package:inventsmart_mobile/pages/sales/sales_page.dart';
import 'package:inventsmart_mobile/pages/stock/stock_page.dart';
import 'package:inventsmart_mobile/pages/alerts/alerts_page.dart';

import '../../services/product_service.dart';
import '../../services/venta_service.dart';
import '../../services/alert_service.dart';
import '../../ui/components/dashboard/header_card.dart';
import '../../ui/components/dashboard/kpi_card.dart';
import '../../ui/components/dashboard/product_item.dart';
import '../../ui/components/buttons/primary_button.dart';
import '../../ui/components/buttons/secondary_button.dart';
import '../../ui/components/inputs/text_input.dart';
import '../../ui/components/layout/page_title.dart';
import '../../ui/components/navbar/custom_navbar.dart';
import '../../ui/components/modals/logout_confirmation_content.dart';
import '../../ui/components/modals/confirmation_modal.dart';
import '../../services/models/product.dart';
import '../../services/models/alerta_model.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  bool isLoading = true;
  List<Product> productos = [];
  Map<String, dynamic> estadisticas = {};
  TextEditingController searchController = TextEditingController();

  // Alertas
  List<Alerta> alertas = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadAlertas();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // =====================
  //  CARGA DE DATOS
  // =====================
  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final stats = await ProductService.getEstadisticas();
      final ventasHoyData = await VentaService.getTotalVentasHoy();
      final ventasTotalesData = await VentaService.getTotalVentas(); // ✅ NUEVO
      final prods = await ProductService.getAllProducts();

      setState(() {
        estadisticas = {
          ...stats,
          'ventas_hoy': ventasHoyData['ventas_hoy'] ?? 0,
          'total_hoy': ventasHoyData['total_hoy'] ?? 0,
          'total_ventas_acumuladas':
              ventasTotalesData['data']['total_ventas'] ?? "0",
        };
        productos = prods;
      });
    } catch (e) {
      debugPrint("Error cargando datos: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error al cargar datos")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // =====================
  //  ALERTAS
  // =====================
  Future<void> _loadAlertas() async {
    try {
      final data = await AlertaService.obtenerAlertas();
      setState(() {
        alertas = data;
      });
    } catch (e) {
      debugPrint("Error alertas: $e");
    }
  }

  // =====================
  //  BÚSQUEDA
  // =====================
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchProducts(query);
    });
  }

  Future<void> _searchProducts(String query) async {
    try {
      final results = query.trim().isEmpty
          ? await ProductService.getAllProducts()
          : await ProductService.searchProducts(query.trim());

      setState(() {
        productos = results;
      });
    } catch (e) {
      debugPrint("Error buscando productos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al buscar productos")));
    }
  }

  // =====================
  //  LOGOUT
  // =====================
  void _showLogoutModal(BuildContext context) {
    showConfirmationModal(
      context: context,
      content: LogoutConfirmationContent(
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CONTENIDO SCROLLEABLE
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // HEADER
                    SliverToBoxAdapter(
                      child: HeaderCard(
                        username: widget.userName,
                        notificationsCount: alertas.length,
                        onNotifications: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AlertsPage()),
                          );
                          _loadAlertas();
                        },
                        onLogout: () => _showLogoutModal(context),
                      ),
                    ),

                    // CONTENIDO
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 18),

                          // BUSCADOR
                          TextInput(
                            hint: "Buscar productos...",
                            controller: searchController,
                            onChanged: _onSearchChanged,
                            suffix: IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.grey),
                              onPressed: () =>
                                  _searchProducts(searchController.text),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // KPI GRID
                          Row(
                            children: [
                              Expanded(
                                child: KpiCard(
                                  icon: Icons.inventory_2_outlined,
                                  iconColor: Colors.blue,
                                  value:
                                      "${estadisticas['total_productos'] ?? 0}",
                                  label: "Productos",
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: KpiCard(
                                  icon: Icons.point_of_sale,
                                  iconColor: Colors.green,
                                  value: "${estadisticas['ventas_hoy'] ?? 0}",
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
                                  icon: Icons.receipt_long,
                                  iconColor: Colors.orange,
                                  value:
                                      "\$${estadisticas['total_ventas_acumuladas'] ?? 0}",
                                  label: "Ventas Totales",
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: KpiCard(
                                  icon: Icons.show_chart,
                                  iconColor: Colors.purple,
                                  value: "\$${estadisticas['total_hoy'] ?? 0}",
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
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SalesPage()),
                                    );
                                    _loadData();
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
                                          builder: (context) =>
                                              const StockPage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // PRODUCTOS RECIENTES (solo activos)
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

                          ...productos
                              .where((p) =>
                                  p.estado.toLowerCase() ==
                                  'activo') // <-- solo activos
                              .map((p) => ProductItem(
                                    name: p.nombre,
                                    stock: "Stock: ${p.stock} unidades",
                                    price: "\$${p.precio}",
                                  )),

                          // Espacio final para navbar
                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),

          // NAVBAR FIJO
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavbar(
              current: currentIndex,
              onChange: (i) => setState(() => currentIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}
