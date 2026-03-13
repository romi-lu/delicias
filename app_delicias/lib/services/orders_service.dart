import '../models/pedido.dart';
import '../models/producto.dart';
import 'api_service.dart';

class OrdersService {
  final ApiService _api;

  OrdersService(this._api);

  Future<List<Pedido>> misPedidos({int pagina = 1, int limite = 20}) async {
    final res = await _api.get('/pedidos/mis-pedidos', queryParameters: {'pagina': pagina, 'limite': limite});
    final list = res['pedidos'] ?? res['data'];
    if (list is List) {
      return list.map((e) => Pedido.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Pedido?> obtenerPedido(int id) async {
    try {
      final res = await _api.get('/pedidos/$id');
      final pedidoData = res['pedido'] as Map<String, dynamic>?;
      final detallesData = res['detalles'] as List<dynamic>?;
      if (pedidoData != null) {
        final detalles = detallesData != null
            ? detallesData.map((e) {
                final m = e as Map<String, dynamic>;
                return PedidoDetalle(
                  id: 0,
                  productoId: null,
                  cantidad: m['cantidad'] as int? ?? 0,
                  precioUnitario: (m['precio_unitario'] as num?)?.toDouble() ?? 0,
                  subtotal: (m['subtotal'] as num?)?.toDouble() ?? 0,
                  producto: m['producto_nombre'] != null
                      ? Producto(id: 0, nombre: m['producto_nombre'] as String, precio: (m['precio_unitario'] as num?)?.toDouble() ?? 0, imagen: m['producto_imagen'] as String?)
                      : null,
                );
              }).toList()
            : <PedidoDetalle>[];
        return Pedido(
          id: pedidoData['id'] as int,
          total: (pedidoData['total'] as num).toDouble(),
          estado: PedidoEstado.fromString(pedidoData['estado'] as String),
          fechaEntrega: pedidoData['fecha_entrega'] != null ? DateTime.tryParse(pedidoData['fecha_entrega'] as String) : null,
          direccionEntrega: pedidoData['direccion_entrega'] as String?,
          telefonoContacto: pedidoData['telefono_contacto'] as String?,
          notas: pedidoData['notas'] as String?,
          createdAt: DateTime.parse(pedidoData['created_at'] as String),
          detalles: detalles,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<CreateOrderResult> crearPedido({
    required List<Map<String, dynamic>> productos,
    String? fechaEntrega,
    String? direccionEntrega,
    String? telefonoContacto,
    String? notas,
  }) async {
    try {
      final res = await _api.post('/pedidos', data: {
        'productos': productos,
        if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
        if (direccionEntrega != null) 'direccion_entrega': direccionEntrega,
        if (telefonoContacto != null) 'telefono_contacto': telefonoContacto,
        if (notas != null) 'notas': notas,
      });
      if (res['statusCode'] == 201) {
        final pedido = res['pedido'] as Map<String, dynamic>?;
        return CreateOrderResult.success(pedido != null ? Pedido.fromJson(pedido) : null);
      }
      return CreateOrderResult.failure(res['message'] as String? ?? 'Error al crear pedido');
    } catch (e) {
      return CreateOrderResult.failure(e.toString().contains('SocketException') ? 'No se pudo conectar al servidor' : 'Error al crear pedido');
    }
  }

  Future<bool> cancelarPedido(int id) async {
    try {
      final res = await _api.put('/pedidos/$id/cancelar');
      return res['statusCode'] == 200;
    } catch (_) {
      return false;
    }
  }
}

class CreateOrderResult {
  final bool success;
  final Pedido? pedido;
  final String? error;

  CreateOrderResult._({this.success = false, this.pedido, this.error});

  factory CreateOrderResult.success(Pedido? pedido) => CreateOrderResult._(success: true, pedido: pedido);
  factory CreateOrderResult.failure(String error) => CreateOrderResult._(success: false, error: error);
}
