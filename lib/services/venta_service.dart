import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/product.dart';

class VentaService {
  static const String baseUrl = "http://192.168.1.27:3000/api";

  /// ✅ REGISTRAR UNA SOLA VENTA POR PRODUCTO
  /*static Future<void> registrarVenta({
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
  }*/

  /// ✅ REGISTRAR TODO EL CARRITO (ENVÍOS MÚLTIPLES)
  static Future<int> registrarVentaCarrito({
    required int usuarioId,
    required Map<Product, int> productos,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ventas/carrito"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "productos": productos.entries
            .map((e) => {
                  "producto_id": e.key.id,
                  "unidades": e.value,
                })
            .toList(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data["message"] ?? "Error registrando venta");
    }

    // ✅ AHORA SI EXISTE
    return data["venta_id"];
  }

  // Total de ventas del día
  static Future<Map<String, dynamic>> getTotalVentasHoy() async {
    final response = await http.get(Uri.parse("$baseUrl/ventas/total-hoy"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception("Error al obtener total de ventas hoy");
    }
  }
  // ✅✅✅ VENTAS TOTALES ACUMULADAS (NUEVO)
  static Future<Map<String, dynamic>> getTotalVentas() async {
    final url = Uri.parse('$baseUrl/ventas/total');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener ventas totales");
    }
  }
}
