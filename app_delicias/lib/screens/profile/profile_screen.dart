import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
      ),
      body: user == null
          ? const Center(child: Text('No hay sesión'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                    child: Text(user.nombre[0].toUpperCase(), style: const TextStyle(fontSize: 48)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: Text(user.nombreCompleto, style: Theme.of(context).textTheme.titleLarge)),
                Center(child: Text(user.email, style: TextStyle(color: Colors.grey[600]))),
                const SizedBox(height: 32),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Mis pedidos'),
                  onTap: () => context.go('/orders'),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Ayuda e información'),
                  onTap: () => context.push('/help'),
                ),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.danger),
                  title: const Text('Cerrar sesión', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w600)),
                  onTap: () async {
                    await auth.logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
    );
  }
}
