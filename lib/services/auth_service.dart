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

  // ✅ SOLICITAR CÓDIGO DE RECUPERACIÓN
  static Future<Map<String, dynamic>> forgotPassword(String correo) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/forgot-password");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "correo": correo,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return {
        "success": true,
        "message": data["message"] ?? "Código enviado exitosamente"
      };
    } else {
      throw Exception(data["message"] ?? "Error al enviar código");
    }
  }

   // ✅ VERIFICAR CÓDIGO (sin consumirlo)
  static Future<Map<String, dynamic>> verifyCode({
    required String correo,
    required String codigo,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/verify-code");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "correo": correo,
        "codigo": codigo,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return {
        "success": true,
        "message": data["message"] ?? "Código válido"
      };
    } else {
      throw Exception(data["message"] ?? "Código inválido o expirado");
    }
  }

  // ✅ RESETEAR CONTRASEÑA CON CÓDIGO
  static Future<Map<String, dynamic>> resetPassword({
    required String correo,
    required String codigo,
    required String nuevaContrasena,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/reset-password");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "correo": correo,
        "codigo": codigo,
        "nuevaContrasena": nuevaContrasena,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return {
        "success": true,
        "message": data["message"] ?? "Contraseña actualizada exitosamente"
      };
    } else {
      throw Exception(data["message"] ?? "Error al resetear contraseña");
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
