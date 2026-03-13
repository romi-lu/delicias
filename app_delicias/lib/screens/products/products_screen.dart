import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../providers/cart_provider.dart';
import '../../services/products_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Producto> _productos = [];
  List<Categoria> _categorias = [];
  bool _loading = true;
  int? _selectedCategoriaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final svc = context.read<ProductsService>();
    final prods = await svc.getProductos(categoriaId: _selectedCategoriaId);
    final cats = await svc.getCategorias();
    if (mounted) {
      setState(() {
        _productos = prods;
        _categorias = cats;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_categorias.isNotEmpty)
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        _ChipFilter(
                          label: 'Todos',
                          selected: _selectedCategoriaId == null,
                          onTap: () {
                            setState(() => _selectedCategoriaId = null);
                            _load();
                          },
                        ),
                        ..._categorias.map((c) => _ChipFilter(
                              label: c.nombre,
                              selected: _selectedCategoriaId == c.id,
                              onTap: () {
                                setState(() => _selectedCategoriaId = c.id);
                                _load();
                              },
                            )),
                      ],
                    ),
                  ),
                Expanded(
                  child: _productos.isEmpty
                      ? const Center(child: Text('No hay productos'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _productos.length,
                          itemBuilder: (_, i) => _ProductCard(producto: _productos[i]),
                        ),
                ),
              ],
            ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipFilter({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;

  const _ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/products/${producto.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: producto.imagenUrl.isNotEmpty
                  ? Image.network(producto.imagenUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text('S/ ${producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 48));
}
