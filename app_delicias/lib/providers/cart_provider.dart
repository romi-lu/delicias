import 'package:flutter/foundation.dart';
import '../models/producto.dart';

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, this.cantidad = 1});

  double get subtotal => producto.precio * cantidad;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.cantidad);

  double get total => _items.fold(0.0, (sum, i) => sum + i.subtotal);

  void add(Producto producto, [int cantidad = 1]) {
    final idx = _items.indexWhere((i) => i.producto.id == producto.id);
    if (idx >= 0) {
      _items[idx].cantidad += cantidad;
    } else {
      _items.add(CartItem(producto: producto, cantidad: cantidad));
    }
    notifyListeners();
  }

  void remove(int productoId) {
    _items.removeWhere((i) => i.producto.id == productoId);
    notifyListeners();
  }

  void updateCantidad(int productoId, int cantidad) {
    if (cantidad <= 0) {
      remove(productoId);
      return;
    }
    final idx = _items.indexWhere((i) => i.producto.id == productoId);
    if (idx >= 0) {
      _items[idx].cantidad = cantidad;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() {
    return _items.map((i) => {'id': i.producto.id, 'cantidad': i.cantidad}).toList();
  }
}
