import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/services/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: product.isOutOfStock
                ? Colors.red.withOpacity(0.3)
                : product.isLowStock
                    ? Colors.orange.withOpacity(0.3)
                    : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícono del producto
              // Ícono del producto
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: product.isOutOfStock
                      ? Colors.red.withOpacity(0.1)
                      : product.isLowStock
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 32,
                  color: product.isOutOfStock
                      ? Colors.red
                      : product.isLowStock
                          ? Colors.orange
                          : Colors.grey.shade600,
                ),
              ),

              const SizedBox(width: 12),

              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStockBadge(),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Categoría
                    if (product.categoria != null)
                      Text(
                        product.categoria!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Stock y precio
                    Row(
                      children: [
                        // Stock
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${product.stock} uds',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: _getStockColor(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Precio
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${product.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge() {
    String text;
    Color bgColor;
    Color textColor;

    if (product.isOutOfStock) {
      text = 'Agotado';
      bgColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
    } else if (product.isLowStock) {
      text = 'Stock Bajo';
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
    } else {
      text = 'En Stock';
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Color _getStockColor() {
    if (product.isOutOfStock) return Colors.red.shade700;
    if (product.isLowStock) return Colors.orange.shade700;
    return Colors.green.shade700;
  }
}
