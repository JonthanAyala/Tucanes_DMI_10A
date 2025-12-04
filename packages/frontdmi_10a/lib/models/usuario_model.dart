// Modelo de Usuario - JaimeCAST69
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol; // cliente, repartidor, admin
  final String? token;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.token,
  });

  // Serialización desde JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? 'cliente',
      token: json['token'],
    );
  }

  // Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'token': token,
    };
  }

  // Copia con modificaciones
  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? rol,
    String? token,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      token: token ?? this.token,
    );
  }
}
