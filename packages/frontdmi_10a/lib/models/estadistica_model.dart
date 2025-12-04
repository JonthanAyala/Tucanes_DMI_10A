// Modelo de estadísticas de paquetes - JonthanAyala
class EstadisticaPaquetes {
  final int totalPaquetes;
  final int pendientes;
  final int enTransito;
  final int entregados;
  final double porcentajeEntregados;

  EstadisticaPaquetes({
    required this.totalPaquetes,
    required this.pendientes,
    required this.enTransito,
    required this.entregados,
    required this.porcentajeEntregados,
  });

  factory EstadisticaPaquetes.fromJson(Map<String, dynamic> json) {
    return EstadisticaPaquetes(
      totalPaquetes: json['totalPaquetes'] ?? 0,
      pendientes: json['pendientes'] ?? 0,
      enTransito: json['enTransito'] ?? 0,
      entregados: json['entregados'] ?? 0,
      porcentajeEntregados: (json['porcentajeEntregados'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPaquetes': totalPaquetes,
      'pendientes': pendientes,
      'enTransito': enTransito,
      'entregados': entregados,
      'porcentajeEntregados': porcentajeEntregados,
    };
  }

  EstadisticaPaquetes copyWith({
    int? totalPaquetes,
    int? pendientes,
    int? enTransito,
    int? entregados,
    double? porcentajeEntregados,
  }) {
    return EstadisticaPaquetes(
      totalPaquetes: totalPaquetes ?? this.totalPaquetes,
      pendientes: pendientes ?? this.pendientes,
      enTransito: enTransito ?? this.enTransito,
      entregados: entregados ?? this.entregados,
      porcentajeEntregados: porcentajeEntregados ?? this.porcentajeEntregados,
    );
  }
}
