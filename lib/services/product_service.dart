import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';
import 'models/product.dart';

class ProductService {
  // Obtener todos los productos
  static Future<List<Product>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesión expirada, vuelva a iniciar sesión");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/productos"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
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

  // Alias para mantener compatibilidad
  static Future<List<Product>> getProductos() async {
    return getAllProducts();
  }

  // Obtener estadísticas
  static Future<Map<String, dynamic>> getEstadisticas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesión expirada, vuelva a iniciar sesión");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/productos/estadisticas"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      return {
        'total_productos': 0,
        'productos_stock': 0,
        'productos_stock_bajo': 0,
        'productos_sin_stock': 0,
      };
    }
  }

  // Buscar productos
  static Future<List<Product>> searchProducts(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesión expirada, vuelva a iniciar sesión");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/productos/search?q=$query"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return (data["data"] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } else {
      return [];
    }
  }

  // Obtener productos con stock bajo
  static Future<List<Product>> getLowStockProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Sesión expirada, vuelva a iniciar sesión");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/productos/stock-bajo"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return (data["data"] as List)
          .map((p) => Product.fromJson(p))
          .toList();
    } else {
      return [];
    }
  }
}