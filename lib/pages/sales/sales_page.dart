import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/pages/sales/SaleConfirmationPage.dart';

// COMPONENTES PROPIOS
import '../../ui/components/layout/screen_wrapper.dart';
import '../../ui/components/layout/page_title.dart';
import '../../ui/components/buttons/primary_button.dart';
import '../../ui/components/inputs/text_input.dart';
import '../../ui/components/modals/confirmation_modal.dart';
import 'package:inventsmart_mobile/services/models/product.dart';
import 'package:inventsmart_mobile/services/product_service.dart';
import '../../ui/theme/colors.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Product> _products = [];
  final Map<Product, int> _cart = {};
  bool _showCart = false;
  bool _loading = true;
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
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
        _products = results;
      });
    } catch (e) {
      debugPrint("Error buscando productos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al buscar productos")));
    }
  }

  Future<void> _loadProducts() async {
    try {
      final data = await ProductService.getProductos();

      setState(() {
        // ✅ SOLO PRODUCTOS ACTIVOS
        _products = data.where((p) => p.estado == "activo").toList();
        _loading = false;
      });
    } catch (e) {
      _loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar productos: $e")),
      );
    }
  }

  double get _total => _cart.entries
      .map((e) => e.key.precio * e.value)
      .fold(0.0, (a, b) => a + b);

  void _addToCart(Product p) {
    setState(() {
      if (_cart.containsKey(p)) {
        if (_cart[p]! < p.stock) _cart[p] = _cart[p]! + 1;
      } else {
        _cart[p] = 1;
      }
    });
  }

  void _removeFromCart(Product p) {
    setState(() {
      if (_cart.containsKey(p)) {
        if (_cart[p]! > 1) {
          _cart[p] = _cart[p]! - 1;
        } else {
          _cart.remove(p);
        }
      }
    });
  }

  void _deleteFromCart(Product p) {
    setState(() => _cart.remove(p));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
        title: const PageTitle(
            title: 'Nueva Venta', size: 20, color: AppColors.background),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: AppColors.background, size: 28),
                onPressed: _cart.isEmpty ? null : () => _openCartModal(context),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _cart.length.toString(),
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInput(
                          hint: "Buscar productos...",
                          controller:
                              searchController, // ✅ usa el controlador existente
                          onChanged: _onSearchChanged,
                          suffix: IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            onPressed: () => _searchProducts(
                                searchController.text), // ✅ también aquí
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// 📦 PRODUCTOS
                        PageTitle(
                          title: "Productos Disponibles (${_products.length})",
                          size: 16,
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true, // ✅ permite crecer según cantidad
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final p = _products[index];

                              return GestureDetector(
                                onTap: () => _addToCart(p),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.inventory_2_rounded,
                                          size: 40, color: AppColors.navy),
                                      const SizedBox(height: 6),
                                      Text(
                                        p.nombre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${p.precio.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: AppColors.navyDark,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        'Stock: ${p.stock}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// ✅ PIE DE VENTA
                /// ✅ CARD DE TOTAL + BOTÓN
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// 🔹 CARD TOTAL
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// TEXTO TOTAL
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${_total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary),
                                ),
                              ],
                            ),

                            /// CANTIDAD DE PRODUCTOS
                            Text(
                              "${_cart.length} productos",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 BOTÓN PROCESAR
                      PrimaryButton(
                        text: "Procesar Venta",
                        onPressed: _cart.isEmpty
                            ? null
                            : () async {
                                final vaciarCarrito = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SaleConfirmationPage(
                                      products: _cart,
                                      total: _total,
                                    ),
                                  ),
                                );

                                // ✅ Si el modal indicó que se finalizó la venta, vaciamos el carrito
                                if (vaciarCarrito == true) {
                                  setState(() {
                                    _cart.clear();
                                  });
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// ✅ MODAL DEL CARRITO
  void _openCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _CartModal(
              cart: _cart,
              total: _total,
              add: (p) {
                _addToCart(p);
                setModalState(() {}); // ✅ actualiza el modal
              },
              remove: (p) {
                _removeFromCart(p);
                setModalState(() {});
              },
              delete: (p) {
                _deleteFromCart(p);
                setModalState(() {});
              },
            );
          },
        );
      },
    );
  }
}

/// ✅ MODAL DEL CARRITO
class _CartModal extends StatelessWidget {
  final Map<Product, int> cart;
  final double total;
  final Function(Product) add;
  final Function(Product) remove;
  final Function(Product) delete;

  const _CartModal({
    super.key,
    required this.cart,
    required this.total,
    required this.add,
    required this.remove,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// ───────── TÍTULO
          const Text(
            "Carrito de Compras",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy),
          ),

          const SizedBox(height: 12),

          /// ───────── LISTA
          Expanded(
            child: ListView(
              children: cart.entries.map((e) {
                final p = e.key;
                final qty = e.value;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(p.nombre),
                    subtitle: Text("\$${p.precio.toStringAsFixed(2)} x $qty"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// ➖ BOTÓN MENOS
                        InkWell(
                          onTap: () {
                            if (qty > 1) {
                              remove(p);
                            } else {
                              delete(
                                  p); // si queda en 1 y presiona -, se elimina
                            }
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                        ),

                        /// 🔢 CANTIDAD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            qty.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// ➕ BOTÓN MÁS
                        InkWell(
                          onTap: () {
                            if (qty < p.stock) {
                              add(p);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("No hay más stock disponible"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// 🗑️ BASURERO ROJO
                        InkWell(
                          onTap: () => delete(p),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(),

          /// ───────── TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ───────── BOTÓN
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // cierra modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Cerrar",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
