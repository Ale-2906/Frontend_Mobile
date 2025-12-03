import 'package:flutter/material.dart';
import '../main.dart';
import 'package:inventsmart_mobile/pages/SaleConfirmationPage.dart';

// COMPONENTES PROPIOS
import '../ui/components/layout/screen_wrapper.dart';
import '../ui/components/layout/page_title.dart';
import '../ui/components/buttons/primary_button.dart';
import '../ui/components/inputs/text_input.dart';
import '../ui/components/modals/confirmation_modal.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final List<_Product> _products = [
    _Product(name: 'Laptop HP 15"', price: 450, stock: 5),
    _Product(name: 'Mouse Logitech', price: 15, stock: 3),
    _Product(name: 'Teclado Mecánico', price: 85, stock: 25),
    _Product(name: 'Monitor LG 24"', price: 199.99, stock: 8),
    _Product(name: 'Disco SSD 1TB', price: 95, stock: 4),
    _Product(name: 'Audífonos In-Ear', price: 12.5, stock: 10),
  ];

  final Map<_Product, int> _cart = {};
  bool _showCart = false;

  double get _total => _cart.entries
      .map((e) => e.key.price * e.value)
      .fold(0.0, (a, b) => a + b);

  void _addToCart(_Product p) {
    setState(() {
      if (_cart.containsKey(p)) {
        if (_cart[p]! < p.stock) _cart[p] = _cart[p]! + 1;
      } else {
        _cart[p] = 1;
      }
    });
  }

  void _removeFromCart(_Product p) {
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

  void _deleteFromCart(_Product p) {
    setState(() => _cart.remove(p));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),

        title: const PageTitle(
          title: 'Nueva Venta',
          size: 20,
        ),

        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: AppColors.textPrimary, size: 28),
                onPressed: _cart.isEmpty ? null : () => _openCartModal(context),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  /// 🔍 BUSCADOR (USANDO TU COMPONENTE)
                  TextInput(
                    hint: "Buscar productos...",
                    controller: TextEditingController(),
                    suffix: const Icon(Icons.search, color: Colors.grey),
                  ),

                  const SizedBox(height: 22),

                  /// 🛒 CARRITO MOSTRAR/OCULTAR
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _showCart && _cart.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PageTitle(title: "Carrito", size: 16),
                              const SizedBox(height: 8),

                              ..._cart.entries.map((e) {
                                final p = e.key;
                                final qty = e.value;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(p.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.textPrimary)),
                                            Text(
                                              '\$${p.price.toStringAsFixed(2)} c/u',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline),
                                            onPressed: () => _removeFromCart(p),
                                          ),
                                          Text(
                                            '$qty',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline),
                                            onPressed: () => _addToCart(p),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close_rounded,
                                                color: Colors.redAccent),
                                            onPressed: () => _deleteFromCart(p),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const SizedBox(height: 12),
                            ],
                          )
                        : const SizedBox(),
                  ),

                  const SizedBox(height: 10),

                  /// 📦 PRODUCTOS
                  PageTitle(
                    title: "Productos Disponibles (${_products.length})",
                    size: 16,
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _products.map((p) {
                      return GestureDetector(
                        onTap: () => _addToCart(p),
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.inventory_2_rounded,
                                  size: 40, color: AppColors.navy),
                              const SizedBox(height: 6),
                              Text(p.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              Text(
                                '\$${p.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Color(0xFF22C55E),
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
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          /// 💰 TOTAL + BOTÓN (REEMPLAZADO CON PrimaryButton)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14)),
                        Text(
                          '\$${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '${_cart.length} productos',
                      style: const TextStyle(color: AppColors.textSecondary),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                PrimaryButton(
                  text: "Procesar Venta",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Venta procesada exitosamente ✅'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SaleConfirmationPage(products: _cart, total: _total),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 MODAL DEL CARRITO (AHORA USA TU MÉTODO showConfirmationModal)
  void _openCartModal(BuildContext context) {
    showConfirmationModal(
      context: context,
      content: _CartModal(
        cart: _cart,
        total: _total,
        add: _addToCart,
        remove: _removeFromCart,
        delete: _deleteFromCart,
      ),
    );
  }
}

class _Product {
  final String name;
  final double price;
  final int stock;
  const _Product(
      {required this.name, required this.price, required this.stock});
}

/// ======================================================
/// WIDGET DEL MODAL (NO TOCA TU LÓGICA, SOLO UI)
/// ======================================================
class _CartModal extends StatelessWidget {
  final Map<_Product, int> cart;
  final double total;
  final Function(_Product) add;
  final Function(_Product) remove;
  final Function(_Product) delete;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Carrito de Compras",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 350,
          child: ListView(
            children: cart.entries.map((e) {
              final p = e.key;
              final qty = e.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary),
                          ),
                          Text(
                            "\$${p.price.toStringAsFixed(2)} c/u",
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => remove(p),
                        ),
                        Text(
                          "$qty",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => add(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.red),
                          onPressed: () => delete(p),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        PrimaryButton(
          text: "Procesar Venta",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
