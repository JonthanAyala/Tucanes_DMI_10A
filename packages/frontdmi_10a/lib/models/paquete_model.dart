import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de Paquete - BojitaNoir
class Paquete {
  final String id;
  final String destinatario;
  final String direccion;
  final double peso;
  final String estado; // pendiente, en_transito, entregado
  final String? fotoUrl;
  final DateTime fechaCreacion;
  final String? repartidorId;
  final String? clienteId;
  final String? codigoQR;

  Paquete({
    required this.id,
    required this.destinatario,
    required this.direccion,
    required this.peso,
    required this.estado,
    this.fotoUrl,
    required this.fechaCreacion,
    this.repartidorId,
    this.clienteId,
    this.codigoQR,
  });

  // Serialización desde JSON
  factory Paquete.fromJson(Map<String, dynamic> json) {
    return Paquete(
      id: json['id'] ?? '',
      destinatario: json['destinatario'] ?? '',
      direccion: json['direccion'] ?? '',
      peso: (json['peso'] ?? 0).toDouble(),
      estado: json['estado'] ?? 'pendiente',
      fotoUrl: json['fotoUrl'],
      fechaCreacion: json['fechaCreacion'] != null
          ? (json['fechaCreacion'] as Timestamp).toDate()
          : DateTime.now(),
      repartidorId: json['repartidorId'],
      clienteId: json['clienteId'],
      codigoQR: json['codigoQR'],
    );
  }

  // Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destinatario': destinatario,
      'direccion': direccion,
      'peso': peso,
      'estado': estado,
      'fotoUrl': fotoUrl,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'repartidorId': repartidorId,
      'clienteId': clienteId,
      'codigoQR': codigoQR,
    };
  }

  // Copia con modificaciones
  Paquete copyWith({
    String? id,
    String? destinatario,
    String? direccion,
    double? peso,
    String? estado,
    String? fotoUrl,
    DateTime? fechaCreacion,
    String? repartidorId,
    String? clienteId,
    String? codigoQR,
  }) {
    return Paquete(
      id: id ?? this.id,
      destinatario: destinatario ?? this.destinatario,
      direccion: direccion ?? this.direccion,
      peso: peso ?? this.peso,
      estado: estado ?? this.estado,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      repartidorId: repartidorId ?? this.repartidorId,
      clienteId: clienteId ?? this.clienteId,
      codigoQR: codigoQR ?? this.codigoQR,
    );
  }
}
