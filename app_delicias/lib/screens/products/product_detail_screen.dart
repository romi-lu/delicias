import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/producto.dart';
import '../../providers/cart_provider.dart';
import '../../services/products_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Producto? _producto;
  bool _loading = true;
  int _cantidad = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final p = await context.read<ProductsService>().getProducto(widget.productId);
    if (mounted) {
      setState(() {
        _producto = p;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_producto == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
        body: const Center(child: Text('Producto no encontrado')),
      );
    }
    final p = _producto!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${context.watch<CartProvider>().itemCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (p.imagenUrl.isNotEmpty)
              Image.network(p.imagenUrl, height: 250, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder())
            else
              _placeholder(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nombre, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('S/ ${p.precio.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  if (p.descripcion != null && p.descripcion!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(p.descripcion!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Cantidad:'),
                      const SizedBox(width: 16),
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _cantidad > 1 ? () => setState(() => _cantidad--) : null),
                      Text('$_cantidad', style: const TextStyle(fontSize: 18)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _cantidad++)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<CartProvider>().add(p, _cantidad);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito')));
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Añadir al carrito'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(height: 250, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 64));
}
