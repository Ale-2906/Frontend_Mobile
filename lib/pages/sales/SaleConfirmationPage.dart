import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/services/models/product.dart';
import 'package:inventsmart_mobile/services/venta_service.dart';
import 'package:inventsmart_mobile/services/session_manager.dart';
import '../../ui/components/layout/section_card.dart';
import '../../ui/components/buttons/primary_button.dart';
import '../../ui/components/buttons/secondary_button.dart';
import '../../ui/components/misc/check_circle.dart';
import '../../ui/theme/colors.dart';
import '../../utils/pdf_utils.dart';

class SaleConfirmationPage extends StatefulWidget {
  final Map<Product, int> products;
  final double total;

  const SaleConfirmationPage({
    super.key,
    required this.products,
    required this.total,
  });

  @override
  State<SaleConfirmationPage> createState() => _SaleConfirmationPageState();
}

class _SaleConfirmationPageState extends State<SaleConfirmationPage> {
  bool _loading = true;
  String _fecha = DateTime.now().toString();
  String _empleado = "Cargando...";
  String _ventaId = "Cargando...";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registrarVenta();
    });
  }

  /// ✅ REGISTRO REAL DE VENTA COMPATIBLE CON TU BACKEND
  Future<void> _registrarVenta() async {
    try {
      final usuario = SessionManager.getUsuario();

      if (usuario == null) {
        throw Exception("No hay usuario en sesión");
      }

      final ventaId = await VentaService.registrarVentaCarrito(
        usuarioId: usuario.id,
        productos: widget.products,
      );

      setState(() {
        _empleado = usuario.nombre;
        _ventaId = ventaId.toString(); // ✅ ID REAL
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _empleado = "Error";
        _ventaId = "Error";
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al registrar venta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

            /// ✅ INFORMACIÓN TRANSACCIÓN
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Información de la Transacción"),
                  const SizedBox(height: 12),
                  _row("Fecha y Hora", _fecha),
                  _row("Empleado", _empleado),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ✅ PRODUCTOS VENDIDOS
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Productos Vendidos"),
                  const SizedBox(height: 12),
                  ...widget.products.entries.map((e) {
                    final p = e.key;
                    final qty = e.value;
                    final subtotal = (p.precio * qty);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.nombre,
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
                            "$qty × \$${p.precio.toStringAsFixed(2)}",
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

            /// ✅ BOTONES
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
                    onPressed: () {
                      generateSaleReceipt(
                        widget.products,
                        widget.total,
                        saleId: _ventaId,
                        employee: _empleado,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
            Text(
              key,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
}
