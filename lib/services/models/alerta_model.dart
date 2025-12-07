enum TipoAlerta {
  agotado,
  critica,
  stockBajo,
}

class Alerta {
  final int id;
  final String titulo;
  final String descripcion;
  final TipoAlerta tipo;
  final int stock;

  Alerta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.stock,
  });

  // ✅ fromJson CORREGIDO para:
  // - AGOTADO (stock == 0)
  // - CRÍTICO (stock <= 5)
  // - STOCK BAJO (stock > 5)
  factory Alerta.fromJson(Map<String, dynamic> json) {
    final int stockActual = json['stock'];

    TipoAlerta tipo;

    if (stockActual == 0) {
      tipo = TipoAlerta.agotado;
    } else if (stockActual < 5) {
      tipo = TipoAlerta.critica;
    } else {
      tipo = TipoAlerta.stockBajo;
    }

    return Alerta(
      id: json['id'],
      titulo: json['nombre'],
      descripcion: "Stock actual: $stockActual",
      stock: stockActual,
      tipo: tipo,
    );
  }
}
