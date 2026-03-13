import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delicias'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _MenuCard(
                  icon: Icons.local_offer_outlined,
                  title: 'Promociones',
                  color: AppTheme.accent,
                  onTap: () => context.go('/products'),
                ),
                _MenuCard(
                  icon: Icons.location_on_outlined,
                  title: 'Seguimiento',
                  color: AppTheme.info,
                  onTap: () => context.go('/orders'),
                ),
                _MenuCard(
                  icon: Icons.cake_outlined,
                  title: 'Nuevos Productos',
                  color: AppTheme.primary,
                  onTap: () => context.go('/products'),
                ),
                _MenuCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chatbot',
                  color: AppTheme.success,
                  onTap: () => context.push('/help'),
                ),
                _MenuCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mi pedido',
                  color: AppTheme.warning,
                  onTap: () => context.go('/orders'),
                ),
                _MenuCard(
                  icon: Icons.help_outline,
                  title: 'Información',
                  color: AppTheme.primaryDark,
                  onTap: () => context.push('/help'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
