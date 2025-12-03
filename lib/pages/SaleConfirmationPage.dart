import 'package:flutter/material.dart';
import '../ui/components/layout/section_card.dart';
import '../ui/components/buttons/primary_button.dart';
import '../ui/components/buttons/secondary_button.dart';
import '../ui/components/misc/check_circle.dart';
import '../ui/theme/colors.dart';

class SaleConfirmationPage extends StatelessWidget {
  final Map<dynamic, int> products; // Producto + cantidad
  final double total;

  const SaleConfirmationPage({
    super.key,
    required this.products,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Detalles de Venta",
          style: TextStyle(color: AppColors.card),
        ),
        backgroundColor: AppColors.navy,
        elevation: 0.2,
        iconTheme: const IconThemeData(color: AppColors.card),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// ✔ CHECK CIRCLE
            const CheckCircle(),

            const SizedBox(height: 12),

            const Text(
              "Venta Completada",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "El stock se ha actualizado automáticamente",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🧾 INFORMACIÓN DE LA TRANSACCIÓN
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Información de la Transacción"),
                  const SizedBox(height: 12),
                  _row("ID de Venta", "#WNT-2024-0342"),
                  _row("Fecha y Hora", "15 Ene 2024, 14:35"),
                  _row("Empleado", "María García"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🛒 PRODUCTOS VENDIDOS
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Productos Vendidos"),
                  const SizedBox(height: 12),
                  ...products.entries.map((e) {
                    final p = e.key;
                    final qty = e.value;
                    final subtotal = (p.price * qty);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${subtotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$qty × \$${p.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔘 BOTONES DE ACCIÓN
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: "Compartir",
                    icon: Icons.share_outlined,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: "Recibo",
                    icon: Icons.receipt_long,
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NUEVA VENTA
            PrimaryButton(
              text: "Nueva Venta",
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔧 WIDGETS REUTILIZABLES
  Widget _title(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      );

  Widget _row(String key, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(key,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14)),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      );
}
