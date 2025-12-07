import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/product.dart';

class VentaService {
  static const String baseUrl = "http://192.168.1.27:3000/api";

  /// ✅ REGISTRAR UNA SOLA VENTA POR PRODUCTO
  static Future<void> registrarVenta({
    required int productoId,
    required int unidades,
    required int usuarioId,
  }) async {
    final url = Uri.parse("$baseUrl/ventas");

    final body = {
      "producto_id": productoId,
      "unidades": unidades,
      "usuario_id": usuarioId,
    };

    print("📤 Enviando venta:");
    print(jsonEncode(body));

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      print("❌ Error backend: ${response.body}");
      throw Exception("Error al registrar la venta");
    }
  }

  /// ✅ REGISTRAR TODO EL CARRITO (ENVÍOS MÚLTIPLES)
  static Future<int> registrarVentaCarrito({
    required int usuarioId,
    required Map<Product, int> productos,
  }) async {
    int ventaId = 0;

    for (final entry in productos.entries) {
      final producto = entry.key;
      final cantidad = entry.value;

      final response = await http.post(
        Uri.parse("$baseUrl/ventas"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "producto_id": producto.id,
          "unidades": cantidad,
          "usuario_id": usuarioId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw Exception(data["message"] ?? "Error registrando venta");
      }

      // ✅ SOLO TOMAMOS EL ID LA PRIMERA VEZ
      ventaId = data["venta_id"];
    }

    return ventaId;
  }
}
