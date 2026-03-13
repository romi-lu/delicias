import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/pedido.dart';
import '../services/orders_service.dart';
import 'orders/order_detail_screen.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  bool _loading = true;
  List<Pedido> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<OrdersService>().misPedidos();
    if (mounted) {
      setState(() {
        _pedidos = list;
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
        title: const Text('Seguimiento', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.muted),
                        const SizedBox(height: 16),
                        const Text(
                          'Aún no tienes pedidos',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                    itemCount: _pedidos.length,
                    itemBuilder: (_, i) {
                      final p = _pedidos[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          tileColor: AppColors.card,
                          title: Text('Pedido #${p.id}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.text)),
                          subtitle: Text(p.estado.displayName, style: const TextStyle(color: AppColors.muted)),
                          trailing: Text('S/ ${p.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: p.id)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
