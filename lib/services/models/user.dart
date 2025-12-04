class User {
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final String token;

  User({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      rol: json['rol'],
      token: token,
    );
  }
}
