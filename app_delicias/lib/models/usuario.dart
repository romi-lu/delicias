class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? direccion;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.direccion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
    );
  }

  String get nombreCompleto => '$nombre $apellido';
}
