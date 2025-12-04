import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api_config.dart';
import 'models/user.dart';

class AuthService {
  static Future<User> login(String correo, String contrasena) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final usuario = data["data"]["usuario"];
      final token = data["data"]["token"];

      // ✅✅✅ GUARDAR TOKEN LOCALMENTE
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return User.fromJson(usuario, token);
    } else {
      throw Exception(data["message"] ?? "Error al iniciar sesión");
    }
  }

  // ✅ CERRAR SESIÓN
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ OBTENER TOKEN DONDE SEA
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
