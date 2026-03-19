import '../config/api_config.dart';

class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int? categoriaId;
  final String? imagen;
  final int stock;
  final bool destacado;
  final bool activo;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.categoriaId,
    this.imagen,
    this.stock = 0,
    this.destacado = false,
    this.activo = true,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      precio: (json['precio'] as num).toDouble(),
      categoriaId: json['categoria_id'] as int?,
      imagen: json['imagen'] as String?,
      stock: json['stock'] as int? ?? 0,
      destacado: json['destacado'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
    );
  }

  String get imagenUrl {
    if (imagen == null || imagen!.isEmpty) return '';
    if (imagen!.startsWith('http')) return imagen!;
    final rel = imagen!.replaceFirst(RegExp(r'^/+'), '');
    return '${ApiConfig.uploadsUrl}/$rel';
  }
}
