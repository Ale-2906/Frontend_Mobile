import 'models/user.dart';

class SessionManager {
  static User? usuarioActual;

  static void setUsuario(User user) {
    usuarioActual = user;
  }

  static User? getUsuario() {
    return usuarioActual;
  }

  static void logout() {
    usuarioActual = null;
  }
}
