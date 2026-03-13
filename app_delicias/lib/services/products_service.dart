import '../models/producto.dart';
import '../models/categoria.dart';
import 'api_service.dart';

class ProductsService {
  final ApiService _api;

  ProductsService(this._api);

  Future<List<Categoria>> getCategorias() async {
    final res = await _api.get('/categorias');
    final list = res is List ? res : (res is Map ? res['data'] ?? res['categorias'] : null);
    if (list is List) {
      return list.map((e) => Categoria.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Producto>> getProductos({int? categoriaId, bool? destacado}) async {
    final params = <String, dynamic>{};
    if (categoriaId != null) params['categoria'] = categoriaId;
    if (destacado == true) params['destacado'] = 'true';
    final queryParams = params.isNotEmpty ? params.map((k, v) => MapEntry(k, v.toString())) : null;
    final res = await _api.get('/productos', queryParameters: queryParams);
    final list = res['productos'] ?? res;
    if (list is List) {
      return list.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Producto?> getProducto(int id) async {
    try {
      final res = await _api.get('/productos/$id');
      if (res is Map<String, dynamic>) {
        return Producto.fromJson(res);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
