import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de Notificación - JonthanAyala
class Notificacion {
  final String id;
  final String userId;
  final String titulo;
  final String mensaje;
  final String tipo; // 'paquete', 'sistema', 'asignacion', etc.
  final DateTime fechaCreacion;
  final bool leida;
  final Map<String, dynamic>? data; // Datos adicionales (ej: paqueteId)

  Notificacion({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.fechaCreacion,
    this.leida = false,
    this.data,
  });

  // Serialización desde JSON
  factory Notificacion.fromJson(Map<String, dynamic> json) {
    // Backend usa 'fecha', frontend usaba 'fechaCreacion'
    final timestamp = json['fecha'] ?? json['fechaCreacion'];

    return Notificacion(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      titulo: json['titulo'] ?? '',
      mensaje: json['mensaje'] ?? '',
      tipo: json['tipo'] ?? 'sistema',
      fechaCreacion: timestamp != null
          ? (timestamp as Timestamp).toDate()
          : DateTime.now(),
      leida: json['leida'] ?? false,
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }

  // Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'titulo': titulo,
      'mensaje': mensaje,
      'tipo': tipo,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'leida': leida,
      'data': data,
    };
  }

  // Copia con modificaciones
  Notificacion copyWith({
    String? id,
    String? userId,
    String? titulo,
    String? mensaje,
    String? tipo,
    DateTime? fechaCreacion,
    bool? leida,
    Map<String, dynamic>? data,
  }) {
    return Notificacion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      leida: leida ?? this.leida,
      data: data ?? this.data,
    );
  }

  // Obtener icono según tipo
  String get icono {
    switch (tipo) {
      case 'paquete':
        return '📦';
      case 'asignacion':
        return '🚚';
      case 'entrega':
        return '✅';
      case 'sistema':
        return 'ℹ️';
      case 'alerta':
        return '⚠️';
      default:
        return '🔔';
    }
  }
}
