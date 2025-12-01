import 'package:flutter/material.dart';
import '../main.dart'; // Para AppColors

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva Venta',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 20)),
            Text('Agrega productos al carrito',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Buscador
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 44,
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
                  const SizedBox(height: 22),

                  // 🛒 Carrito
                  if (_cart.isNotEmpty) ...[
                    const Text('Carrito',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary)),
                                  Text('\$${p.price.toStringAsFixed(2)} c/u',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: AppColors.textSecondary),
                                  onPressed: () => _removeFromCart(p),
                                ),
                                Text('$qty',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: AppColors.navy),
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

                  // 📦 Productos disponibles
                  Text('Productos Disponibles (${_products.length})',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
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
                              Text('\$${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontWeight: FontWeight.w800)),
                              Text('Stock: ${p.stock}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
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

          // 💰 Total y botón
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
                        Text('\$${_total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const Spacer(),
                    Text('${_cart.length} productos',
                        style: const TextStyle(color: AppColors.textSecondary))
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _cart.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Venta procesada exitosamente ✅'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            setState(() => _cart.clear());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                    ),
                    child: const Text('Procesar Venta',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
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

class _Product {
  final String name;
  final double price;
  final int stock;
  const _Product(
      {required this.name, required this.price, required this.stock});
}
