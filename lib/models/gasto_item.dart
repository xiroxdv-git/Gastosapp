class GastoItem {
  final String titulo;
  final double monto;
  final DateTime fecha;
  final String categoria;

  GastoItem({
    required this.titulo,
    required this.monto,
    required this.fecha,
    required this.categoria,
  });

  // Convertir objeto a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
    };
  }

  // Crear objeto desde Map (JSON)
  factory GastoItem.fromJson(Map<String, dynamic> json) {
    return GastoItem(
      titulo: json['titulo'] as String,
      monto: (json['monto'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
      categoria: json['categoria'] as String,
    );
  }
}