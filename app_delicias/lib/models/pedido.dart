import 'producto.dart';

enum PedidoEstado {
  pendiente,
  confirmado,
  enPreparacion,
  listo,
  entregado,
  cancelado;

  static PedidoEstado fromString(String value) {
    final normalized = value.toLowerCase().replaceAll(' ', '_');
    for (final e in PedidoEstado.values) {
      if (e.apiValue == normalized) return e;
    }
    return PedidoEstado.pendiente;
  }

  String get apiValue {
    switch (this) {
      case PedidoEstado.enPreparacion:
        return 'en_preparacion';
      default:
        return name;
    }
  }

  String get displayName {
    switch (this) {
      case PedidoEstado.pendiente:
        return 'Pendiente';
      case PedidoEstado.confirmado:
        return 'Confirmado';
      case PedidoEstado.enPreparacion:
        return 'En preparación';
      case PedidoEstado.listo:
        return 'Listo';
      case PedidoEstado.entregado:
        return 'Entregado';
      case PedidoEstado.cancelado:
        return 'Cancelado';
    }
  }
}

class PedidoDetalle {
  final int id;
  final int? productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final Producto? producto;

  PedidoDetalle({
    required this.id,
    this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.producto,
  });

  factory PedidoDetalle.fromJson(Map<String, dynamic> json) {
    return PedidoDetalle(
      id: json['id'] as int,
      productoId: json['producto_id'] as int?,
      cantidad: json['cantidad'] as int,
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      producto: json['producto'] != null
          ? Producto.fromJson(json['producto'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Pedido {
  final int id;
  final double total;
  final PedidoEstado estado;
  final DateTime? fechaEntrega;
  final String? direccionEntrega;
  final String? telefonoContacto;
  final String? notas;
  final DateTime createdAt;
  final List<PedidoDetalle> detalles;

  Pedido({
    required this.id,
    required this.total,
    required this.estado,
    this.fechaEntrega,
    this.direccionEntrega,
    this.telefonoContacto,
    this.notas,
    required this.createdAt,
    this.detalles = const [],
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    List<PedidoDetalle> detalles = [];
    final detallesJson = json['detalles'] as List<dynamic>?;
    if (detallesJson != null) {
      for (final e in detallesJson) {
        final m = e as Map<String, dynamic>;
        detalles.add(PedidoDetalle(
          id: m['id'] as int? ?? 0,
          productoId: null,
          cantidad: m['cantidad'] as int? ?? 0,
          precioUnitario: (m['precio_unitario'] as num?)?.toDouble() ?? 0,
          subtotal: (m['subtotal'] as num?)?.toDouble() ?? 0,
          producto: m['producto_nombre'] != null
              ? Producto(id: 0, nombre: m['producto_nombre'] as String, precio: (m['precio_unitario'] as num?)?.toDouble() ?? 0, imagen: m['producto_imagen'] as String?)
              : null,
        ));
      }
    }
    return Pedido(
      id: json['id'] as int,
      total: (json['total'] as num).toDouble(),
      estado: PedidoEstado.fromString(json['estado'] as String),
      fechaEntrega: json['fecha_entrega'] != null
          ? DateTime.tryParse(json['fecha_entrega'] as String)
          : null,
      direccionEntrega: json['direccion_entrega'] as String?,
      telefonoContacto: json['telefono_contacto'] as String?,
      notas: json['notas'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      detalles: detalles,
    );
  }

  bool get enCamino =>
      estado == PedidoEstado.confirmado ||
      estado == PedidoEstado.enPreparacion ||
      estado == PedidoEstado.listo;
}
