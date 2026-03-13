import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/producto.dart';
import '../services/products_service.dart';
import 'productos_screen.dart';

class PromocionesScreen extends StatefulWidget {
  const PromocionesScreen({super.key});

  @override
  State<PromocionesScreen> createState() => _PromocionesScreenState();
}

class _PromocionesScreenState extends State<PromocionesScreen> {
  bool _loading = true;
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<ProductsService>().getProductos(destacado: true);
    if (mounted) {
      setState(() {
        _productos = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.text), onPressed: () => Navigator.pop(context)),
          title: const Text('Promociones', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_productos.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.text), onPressed: () => Navigator.pop(context)),
          title: const Text('Promociones', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
        ),
        body: const Center(child: Text('No hay promociones activas')),
      );
    }
    return ProductosScreen(productos: _productos, title: 'Promociones');
  }
}
