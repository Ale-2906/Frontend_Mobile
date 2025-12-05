class Product {
  final int id;
  final String nombre;
  final double precio;
  final int stock;
  final String estado; // ✅ OBLIGATORIO

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.estado,
  });

  String get name => nombre;
  double get price => precio;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      stock: json['stock'],
      estado: json['estado'], // ✅ AQUÍ TAMBIÉN
    );
  }
}
