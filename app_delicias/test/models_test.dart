import 'package:flutter_test/flutter_test.dart';
import 'package:app_delicias/models/producto.dart';
import 'package:app_delicias/models/categoria.dart';
import 'package:app_delicias/models/pedido.dart';
import 'package:app_delicias/models/usuario.dart';

void main() {
  group('Producto', () {
    test('fromJson crea Producto correctamente', () {
      final json = {
        'id': 1,
        'nombre': 'Pan Integral',
        'precio': 5.50,
        'descripcion': 'Pan saludable',
      };
      final p = Producto.fromJson(json);
      expect(p.id, 1);
      expect(p.nombre, 'Pan Integral');
      expect(p.precio, 5.50);
      expect(p.descripcion, 'Pan saludable');
    });
  });

  group('Categoria', () {
    test('fromJson crea Categoria correctamente', () {
      final json = {'id': 1, 'nombre': 'Panes', 'activo': true};
      final c = Categoria.fromJson(json);
      expect(c.id, 1);
      expect(c.nombre, 'Panes');
      expect(c.activo, true);
    });
  });

  group('Usuario', () {
    test('nombreCompleto concatena nombre y apellido', () {
      final u = Usuario(id: 1, nombre: 'Juan', apellido: 'Pérez', email: 'juan@test.com');
      expect(u.nombreCompleto, 'Juan Pérez');
    });
  });

  group('PedidoEstado', () {
    test('fromString parsea estados correctamente', () {
      expect(PedidoEstado.fromString('pendiente'), PedidoEstado.pendiente);
      expect(PedidoEstado.fromString('en_preparacion'), PedidoEstado.enPreparacion);
      expect(PedidoEstado.fromString('entregado'), PedidoEstado.entregado);
    });
  });
}
