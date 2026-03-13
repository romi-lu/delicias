import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_shell.dart';
import 'orders/order_detail_screen.dart';

class PagoExitosoScreen extends StatelessWidget {
  final int orderId;

  const PagoExitosoScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AppShell()),
            (route) => false,
          ),
        ),
        title: const Text('Pago exitoso', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              '¡Pago realizado con éxito!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.text),
            ),
            const SizedBox(height: 8),
            Text(
              'Orden #$orderId',
              style: const TextStyle(fontSize: 16, color: AppColors.muted),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
                ),
                child: const Text('Seguir pedido', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AppShell()),
                  (route) => false,
                ),
                child: const Text('Volver al inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
