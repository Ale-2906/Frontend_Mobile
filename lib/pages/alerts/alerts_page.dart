import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/services/alert_service.dart';
import 'package:inventsmart_mobile/services/models/alerta_model.dart';

import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<Alerta> alertas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAlertas();
  }

  Future<void> cargarAlertas() async {
    try {
      final data = await AlertaService.obtenerAlertas();
      setState(() {
        alertas = data;
        cargando = false;
      });
    } catch (e) {
      debugPrint("Error alertas: $e");
      setState(() => cargando = false);
    }
  }

  // =============================
  //  COLORES POR TIPO DE ALERTA
  // =============================
  Color _getColor(TipoAlerta tipo) {
    switch (tipo) {
      case TipoAlerta.agotado:
        return AppColors.danger;
      case TipoAlerta.critica:
        return Colors.orange;
      case TipoAlerta.stockBajo:
        return AppColors.navy;
    }
  }

  // =============================
  //  TEXTO POR TIPO DE ALERTA
  // =============================
  String _getLabel(TipoAlerta tipo) {
    switch (tipo) {
      case TipoAlerta.agotado:
        return "AGOTADO";
      case TipoAlerta.critica:
        return "CRÍTICO";
      case TipoAlerta.stockBajo:
        return "STOCK BAJO";
    }
  }

  // =============================
  //  ICONO POR TIPO DE ALERTA
  // =============================
  IconData _getIcon(TipoAlerta tipo) {
    switch (tipo) {
      case TipoAlerta.agotado:
        return Icons.error;
      case TipoAlerta.critica:
        return Icons.warning;
      case TipoAlerta.stockBajo:
        return Icons.inventory_2;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        iconTheme: const IconThemeData(color: Colors.white), // Flecha blanca
        title: const Text(
          "Alertas",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : _alertasActivas(),
    );
  }

  Widget _alertasActivas() {
    if (alertas.isEmpty) {
      return const Center(
        child: Text(
          "✅ No hay productos con stock bajo",
          style: AppTextStyles.subtitle,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: alertas.length,
      itemBuilder: (context, i) {
        final alerta = alertas[i];
        final color = _getColor(alerta.tipo);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICONO
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIcon(alerta.tipo), color: color, size: 28),
              ),

              const SizedBox(width: 12),

              // DETALLES
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITULO Y CHIP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alerta.titulo,
                          style: AppTextStyles.subtitle
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getLabel(alerta.tipo),
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // DESCRIPCIÓN
                    Text(alerta.descripcion, style: AppTextStyles.body),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
