import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/pedido.dart';
import '../../services/orders_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Pedido> _pedidos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
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
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(child: Text('No tienes pedidos'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pedidos.length,
                    itemBuilder: (_, i) {
                      final p = _pedidos[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Pedido #${p.id}'),
                          subtitle: Text(p.estado.displayName),
                          trailing: Text('S/ ${p.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () => context.push('/orders/${p.id}'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
