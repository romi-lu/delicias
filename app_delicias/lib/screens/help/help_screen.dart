import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Información y ayuda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: '¿Cómo hacer pedidos?', content: 'Puedes realizar pedidos desde la sección Tienda. Añade productos al carrito y finaliza tu compra. También puedes pedir desde nuestra página web.'),
          _Section(title: 'Horarios de atención', content: 'Lunes a Domingo: 7:00 AM - 9:00 PM'),
          _Section(title: 'Pago con tarjeta', content: 'Aceptamos pagos con tarjeta de crédito y débito. También ofrecemos pago contra entrega en efectivo.'),
          _Section(title: 'Política de devoluciones', content: 'Para productos en mal estado, contacta con nosotros dentro de las 24 horas posteriores a la entrega.'),
          _Section(title: 'Ubicación y contacto', content: 'Visítanos en nuestra tienda o contáctanos por teléfono para más información.'),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [Padding(padding: const EdgeInsets.all(16), child: Text(content))],
      ),
    );
  }
}
