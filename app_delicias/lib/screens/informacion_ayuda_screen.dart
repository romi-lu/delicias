import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/delicias_appbar.dart';
import '../widgets/delicias_card.dart';

class InformacionAyudaScreen extends StatefulWidget {
  const InformacionAyudaScreen({super.key});

  @override
  State<InformacionAyudaScreen> createState() => _InformacionAyudaScreenState();
}

class _InformacionAyudaScreenState extends State<InformacionAyudaScreen> {
  final items = [
    _AyudaItem('¿Cómo hacer pedidos en la web?', [
      {'Paso': '1', 'Descripción': 'Ir al sitio web y seleccionar productos.'},
      {'Paso': '2', 'Descripción': 'Añadir productos al carrito.'},
      {'Paso': '3', 'Descripción': 'Realizar el pago con tarjeta.'},
    ]),
    _AyudaItem('Hora de atención', [
      {'Día': 'Lunes a Viernes', 'Hora': '9:00 AM - 6:00 PM'},
      {'Sábado': '8:00 AM - 2:00 PM'},
      {'Domingo': 'Cerrado'},
    ]),
    _AyudaItem('Pago con tarjeta', [
      {'Método': 'Visa', 'Descripción': 'Pago seguro con tarjeta Visa.'},
      {'Método': 'Mastercard', 'Descripción': 'Pago seguro con tarjeta Mastercard.'},
    ]),
    _AyudaItem('Política de devoluciones', [
      {'Condición': 'Producto en mal estado', 'Acción': 'Reemplazo o devolución del dinero.'},
      {'Condición': 'Producto no usado', 'Acción': 'Devolución en 15 días.'},
    ]),
    _AyudaItem('Ubicación y contacto', [
      {'Dirección': 'Jr. Parra del Riego', 'Teléfono': '+51 234 567 890'},
      {'Email': 'delicias@empresa.com', 'Sitio Web': 'www.delicias.com'},
    ]),
  ];

  void _openDialog(String title) {
    final item = items.firstWhere((i) => i.titulo == title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: DataTable(
            columns: const [DataColumn(label: Text('Clave')), DataColumn(label: Text('Detalle'))],
            rows: item.detalles.map((e) => DataRow(cells: [DataCell(Text(e.keys.first)), DataCell(Text(e.values.first))])).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const DeliciasAppBar(title: 'Información / Ayuda'),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(18),
          itemBuilder: (_, i) => DeliciasCard(
            onTap: () => _openDialog(items[i].titulo),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    items[i].titulo,
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.text),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.text),
              ],
            ),
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemCount: items.length,
        ),
      ),
    );
  }
}

class _AyudaItem {
  final String titulo;
  final List<Map<String, String>> detalles;
  _AyudaItem(this.titulo, this.detalles);
}
