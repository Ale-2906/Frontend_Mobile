import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/ui/theme/colors.dart';
import 'package:inventsmart_mobile/models/product.dart';

class ProductRow extends StatelessWidget {
  final Product product;
  final int quantity;

  const ProductRow({super.key, required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final subtotal = product.price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              Text("\$${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Text("$quantity × \$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
