import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../models/producto.dart';
import '../providers/cart_provider.dart';
import '../services/products_service.dart';

class ProductosScreen extends StatefulWidget {
  final List<Producto>? productos;
  final String title;

  const ProductosScreen({super.key, this.productos, this.title = 'Nuevos Productos'});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List<Producto> _productos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.productos != null) {
      setState(() {
        _productos = widget.productos!;
        _loading = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<ProductsService>().getProductos();
    if (mounted) {
      setState(() {
        _productos = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title, style: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: _loading
          ? _buildShimmerList()
          : _productos.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                  itemCount: _productos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) {
                    final p = _productos[i];
                    return _ProductCard(
                      producto: p,
                      index: i,
                      onAdd: () {
                        context.read<CartProvider>().add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.nombre} agregado ✅'),
                            duration: const Duration(milliseconds: 800),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.card2,
        highlightColor: Colors.white,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bakery_dining_outlined, size: 64, color: AppColors.muted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No hay productos disponibles',
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onAdd;
  final int index;

  const _ProductCard({required this.producto, required this.onAdd, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 82,
              height: 82,
              child: producto.imagenUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: producto.imagenUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.card2, child: const Center(child: CircularProgressIndicator(color: AppColors.primary))),
                      errorWidget: (_, __, ___) => Container(color: AppColors.card2, child: const Icon(Icons.bakery_dining, size: 36, color: AppColors.primary)),
                    )
                  : Container(color: AppColors.card2, child: const Icon(Icons.bakery_dining, size: 36, color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  producto.nombre,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'S/${producto.precio.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  producto.descripcion ?? 'Producto recomendado',
                  style: GoogleFonts.poppins(fontSize: 12, height: 1.2, color: AppColors.muted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                elevation: 0,
              ),
              child: Text('Agregar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.02, end: 0, curve: Curves.easeOut);
  }
}
