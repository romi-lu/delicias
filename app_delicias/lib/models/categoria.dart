class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagen;
  final bool activo;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagen,
    this.activo = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      imagen: json['imagen'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }
}
