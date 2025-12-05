class Product {
  final int id;
  final String nombre;
  final double precio;
  final int stock;
  final int stockMinimo;  // ✅ AGREGAR
  final String estado;
  final String? categoria;
  final String? proveedor;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.stockMinimo,  // ✅ AGREGAR
    required this.estado,
    this.categoria,
    this.proveedor,
  });

  // Getters en inglés para compatibilidad
  String get name => nombre;
  double get price => precio;

  // Determinar el estado del stock
  String get stockStatus {
    if (stock == 0) return 'agotado';
    if (stock <= stockMinimo) return 'bajo';
    return 'normal';
  }

  // ✅ AGREGAR estos getters que usa ProductCard
  bool get isLowStock => stock <= stockMinimo && stock > 0;
  bool get isOutOfStock => stock == 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      stock: json['stock'],
      stockMinimo: json['stock_minimo'] ?? 5,  // ✅ AGREGAR
      estado: json['estado'],
      categoria: json['categoria_nombre'],  // ✅ AGREGAR
      proveedor: json['proveedor_nombre'],  // ✅ AGREGAR
    );
  }
}