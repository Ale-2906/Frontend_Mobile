import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventsmart_mobile/services/auth_service.dart';
import 'package:inventsmart_mobile/services/config/api_config.dart';
import 'models/alerta_model.dart';

class AlertaService {
  static Future<List<Alerta>> obtenerAlertas() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token no disponible");
    }

    final url = Uri.parse("${ApiConfig.baseUrl}/productos/stock-bajo");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data["data"] as List)
          .map((e) => Alerta.fromJson(e))
          .toList();
    } else {
      throw Exception("Error ${response.statusCode} al cargar alertas");
    }
  }
}
