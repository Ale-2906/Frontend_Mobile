import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';
import 'models/product.dart';

class ProductService {
  static Future<List<Product>> getProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesión expirada, vuelva a iniciar sesión");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/productos"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // 🔥 CLAVE PARA EL 401
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return (data["data"] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } else {
      throw Exception(data["message"] ?? "Error al obtener productos");
    }
  }
}
