import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../models/pedido.dart';
import '../../services/orders_service.dart';
import '../../widgets/order_tracking_map.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Pedido? _pedido;
  bool _loading = true;

  LatLng? _tryParseLatLng(String? input) {
    if (input == null) return null;
    final m = RegExp(r'(-?\d+(?:\.\d+)?)\s*[, ]\s*(-?\d+(?:\.\d+)?)').firstMatch(input);
    if (m == null) return null;
    final lat = double.tryParse(m.group(1) ?? '');
    final lng = double.tryParse(m.group(2) ?? '');
    if (lat == null || lng == null) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    return LatLng(lat, lng);
  }

  int _trackingStage(PedidoEstado estado) {
    switch (estado) {
      case PedidoEstado.entregado:
        return 2;
      case PedidoEstado.listo:
        return 1;
      case PedidoEstado.cancelado:
        return 0;
      case PedidoEstado.pendiente:
      case PedidoEstado.confirmado:
      case PedidoEstado.enPreparacion:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final p = await context.read<OrdersService>().obtenerPedido(widget.orderId);
    if (mounted) {
      setState(() {
        _pedido = p;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_pedido == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
        body: const Center(child: Text('Pedido no encontrado')),
      );
    }
    final p = _pedido!;
    final stage = _trackingStage(p.estado);
    final steps3 = const ['Preparando', 'En camino', 'Entregado'];
    final destination = _tryParseLatLng(p.direccionEntrega);
    const store = LatLng(-12.046374, -77.042793); // Lima (placeholder)
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Pedido #${p.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seguimiento de pedido', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ThreeStepProgress(steps: steps3, currentIndex: stage),
            const SizedBox(height: 14),
            Text(p.estado.displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.text)),
            const SizedBox(height: 14),
            OrderTrackingMap(
              store: store,
              destination: destination,
              height: 240,
            ),
            const Divider(height: 32),
            if (p.detalles.isNotEmpty) ...[
              const Text('Productos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...p.detalles.map((d) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(d.producto?.nombre ?? 'Producto'),
                    subtitle: Text('${d.cantidad} x S/ ${d.precioUnitario.toStringAsFixed(2)}'),
                    trailing: Text('S/ ${d.subtotal.toStringAsFixed(2)}'),
                  )),
              const Divider(height: 32),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18)),
                Text('S/ ${p.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            if (p.estado != PedidoEstado.cancelado && p.estado != PedidoEstado.entregado && p.estado != PedidoEstado.listo) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final ordersService = context.read<OrdersService>();
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await ordersService.cancelarPedido(p.id);
                    if (!mounted) return;
                    if (ok) {
                      messenger.showSnackBar(const SnackBar(content: Text('Pedido cancelado')));
                      _load();
                    }
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                  child: const Text('Cancelar pedido'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThreeStepProgress extends StatelessWidget {
  final List<String> steps;
  final int currentIndex;

  const _ThreeStepProgress({
    required this.steps,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final active = AppColors.primary;
    final muted = Colors.black26;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2E3C6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final lineActive = (i ~/ 2) < currentIndex;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: lineActive ? active : muted,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < currentIndex;
          final isCurrent = idx == currentIndex;
          final color = done || isCurrent ? active : muted;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: done ? active : Colors.white,
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 78,
                child: Text(
                  steps[idx],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                    color: done || isCurrent ? AppColors.text : Colors.black45,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
