import 'detalle_venta.dart';

class Venta {
  final int usuarioId;
  final double total;
  final List<DetalleVenta> detalles;

  Venta({
    required this.usuarioId,
    required this.total,
    required this.detalles,
  });

  Map<String, dynamic> toJson() {
    return {
      "usuarioId": usuarioId,
      "total": total,
      "detalles": detalles.map((d) => d.toJson()).toList(),
    };
  }
}
