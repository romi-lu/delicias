import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../services/orders_service.dart';
import 'pago_exitoso_screen.dart';

class ProcesoPagoScreen extends StatefulWidget {
  const ProcesoPagoScreen({super.key});

  @override
  State<ProcesoPagoScreen> createState() => _ProcesoPagoScreenState();
}

class _ProcesoPagoScreenState extends State<ProcesoPagoScreen> {
  String _metodo = 'Contra entrega';
  bool _loading = false;
  final _nTarjeta = TextEditingController();
  final _titular = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _nTarjeta.dispose();
    _titular.dispose();
    _cvv.dispose();
    super.dispose();
  }

  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pagar() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      _msg('Tu carrito está vacío');
      return;
    }
    if (_metodo == 'Tarjeta') {
      if (_nTarjeta.text.trim().length < 12 || _cvv.text.trim().length < 3) {
        _msg('Completa bien los datos de tarjeta');
        return;
      }
    }

    setState(() => _loading = true);

    final result = await context.read<OrdersService>().crearPedido(
          productos: cart.toOrderItems(),
          notas: 'Pago: $_metodo',
        );

    if (!mounted) return;

    setState(() => _loading = false);

    if (result.success) {
      cart.clear();
      final orderId = result.pedido?.id ?? 0;
      if (orderId > 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('lastOrderId', orderId);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PagoExitosoScreen(orderId: orderId)),
      );
    } else {
      _msg(result.error ?? 'No se pudo crear el pedido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

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
        title: const Text('Proceso de pago', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Total a pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
                  ),
                  Text('S/${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.text)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Método de pago', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                  const SizedBox(height: 10),
                  _radio('Contra entrega'),
                  _radio('Yape'),
                  _radio('Tarjeta'),
                  if (_metodo == 'Tarjeta') ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nTarjeta,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Número de tarjeta'),
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: _titular, decoration: const InputDecoration(labelText: 'Titular')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cvv,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      obscureText: true,
                    ),
                  ],
                  if (_metodo == 'Yape') ...[
                    const SizedBox(height: 12),
                    const Text('Yape: 999 888 777  (Delicias del Centro)', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _pagar,
                      child: const Text('Pagar', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radio(String label) {
    return RadioListTile<String>(
      value: label,
      groupValue: _metodo,
      onChanged: (v) => setState(() => _metodo = v!),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
      activeColor: AppColors.accent,
      contentPadding: EdgeInsets.zero,
    );
  }
}
