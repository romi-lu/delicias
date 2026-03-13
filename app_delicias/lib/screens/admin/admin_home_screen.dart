import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Usuarios'),
              subtitle: const Text('Gestionar usuarios del sistema'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accede al panel web para gestión completa'))),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Productos'),
              subtitle: const Text('Gestionar catálogo de productos'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accede al panel web para gestión completa'))),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Pedidos'),
              subtitle: const Text('Ver y gestionar pedidos'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accede al panel web para gestión completa'))),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.route_outlined),
              title: const Text('Rutas de entrega'),
              subtitle: const Text('Planificar rutas de reparto'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente'))),
            ),
          ),
        ],
      ),
    );
  }
}
