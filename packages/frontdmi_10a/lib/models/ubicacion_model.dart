// Modelo de ubicación para geolocalización - BojitaNoir
class Ubicacion {
  final double latitud;
  final double longitud;
  final DateTime timestamp;
  final String? repartidorId;

  Ubicacion({
    required this.latitud,
    required this.longitud,
    required this.timestamp,
    this.repartidorId,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'latitud': latitud,
      'longitud': longitud,
      'timestamp': timestamp.toIso8601String(),
      'repartidorId': repartidorId,
    };
  }

  // Crear desde JSON
  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      latitud: json['latitud'] as double,
      longitud: json['longitud'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
      repartidorId: json['repartidorId'] as String?,
    );
  }

  // Copiar con modificaciones
  Ubicacion copyWith({
    double? latitud,
    double? longitud,
    DateTime? timestamp,
    String? repartidorId,
  }) {
    return Ubicacion(
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      timestamp: timestamp ?? this.timestamp,
      repartidorId: repartidorId ?? this.repartidorId,
    );
  }
}
