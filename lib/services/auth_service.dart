// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // kReleaseMode
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _base = 'https://reqres.in/api';
  static const _storage = FlutterSecureStorage();

  static Future<String> login(String email, String password) async {
    // MOCK en desarrollo: acepta cualquier correo válido + pass >=4
    if (!kReleaseMode) {
      final okEmail = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(email);
      if (okEmail && password.length >= 4) {
        const fakeToken = 'dev_fake_token_123';
        await _storage.write(key: 'token', value: fakeToken);
        return fakeToken;
      }
    }

    // PRODUCCIÓN: llamada real
    final url = Uri.parse('$_base/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // Para depurar desde la consola del navegador
    // ignore: avoid_print
    print('LOGIN status: ${res.statusCode} body: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'] as String;
      await _storage.write(key: 'token', value: token);
      return token;
    } else {
      final body = jsonDecode(res.body.isEmpty ? '{}' : res.body);
      final msg = body['error'] ?? 'Credenciales inválidas';
      throw Exception(msg);
    }
  }

  static Future<void> logout() async => _storage.delete(key: 'token');
  static Future<String?> getToken() => _storage.read(key: 'token');
}
