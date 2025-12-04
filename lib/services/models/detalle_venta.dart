class DetalleVenta {
  final int productoId;
  final int cantidad;
  final double precio;

  DetalleVenta({
    required this.productoId,
    required this.cantidad,
    required this.precio,
  });

  Map<String, dynamic> toJson() {
    return {
      "productoId": productoId,
      "cantidad": cantidad,
      "precio": precio,
    };
  }
}
