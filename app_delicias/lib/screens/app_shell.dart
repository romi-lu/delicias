import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'auth/login_screen.dart';
import 'promociones_screen.dart';
import 'seguimiento_screen.dart';
import 'productos_screen.dart';
import 'chat_bot_screen.dart';
import 'pedidos_cart_screen.dart';
import 'perfil_screen.dart';
import 'informacion_ayuda_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  void _openSeguimiento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SeguimientoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final userName = context.watch<AuthProvider>().user?.nombreCompleto ?? 'Usuario';

    final pages = <Widget>[
      _HomeGrid(
        userName: userName,
        openSeguimiento: _openSeguimiento,
        cartCount: cartCount,
      ),
      const ChatBotScreen(),
      const PedidosCartScreen(),
      const PerfilScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Icon(Icons.person_rounded, size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.watch<AuthProvider>().user?.email ?? '',
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_outline_rounded, color: AppColors.primary),
                title: Text('Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _tab = 3);
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                title: Text('Mis pedidos', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _tab = 2);
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline_rounded, color: AppColors.primary),
                title: Text('Ayuda', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InformacionAyudaScreen()),
                  );
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
                title: Text('Cerrar sesión', style: GoogleFonts.poppins(color: AppColors.danger, fontWeight: FontWeight.w600)),
                onTap: () async {
                  await context.read<AuthProvider>().logout();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _tab == 0 ? 'Inicio' : _tab == 1 ? 'Chatbot' : _tab == 2 ? 'Carrito' : 'Perfil',
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppColors.text),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: bottomBar(context),
    );
  }

  Widget bottomBar(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: AppShadows.soft,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'Inicio'),
              _navItem(1, Icons.smart_toy_rounded, 'Chatbot'),
              _navItem(2, Icons.shopping_cart_rounded, 'Carrito', badge: cartCount),
              _navItem(3, Icons.person_rounded, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, {int badge = 0}) {
    final selected = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: selected ? AppColors.primary : AppColors.muted,
                ),
                if (badge > 0)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badge',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeGrid extends StatelessWidget {
  final String userName;
  final VoidCallback openSeguimiento;
  final int cartCount;

  const _HomeGrid({
    required this.userName,
    required this.openSeguimiento,
    required this.cartCount,
  });

  static const _items = [
    ('Promociones', Icons.local_offer_rounded, Color(0xFFE8A85C), false),
    ('Seguimiento', Icons.local_shipping_rounded, Color(0xFFD4A574), true),
    ('Productos', Icons.bakery_dining_rounded, Color(0xFFC17F3A), false),
    ('Chatbot', Icons.smart_toy_rounded, Color(0xFF8B9BA8), false),
    ('Mi pedido', Icons.inventory_2_rounded, Color(0xFFE0A95F), false),
    ('Información', Icons.info_rounded, Color(0xFF5C7A9E), false),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, $userName',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.02, end: 0),
          const SizedBox(height: 6),
          Text(
            '¿Qué te gustaría hacer hoy?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.muted,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
              ),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final (title, icon, color, isAction) = _items[i];
                final badge = (title == 'Mi pedido') ? cartCount : 0;
                return _HomeCard(
                  title: title,
                  icon: icon,
                  color: color,
                  badge: badge,
                  delay: 150 + (i * 80),
                  onTap: isAction
                      ? openSeguimiento
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _pageFor(title),
                            ),
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _pageFor(String title) {
    switch (title) {
      case 'Promociones':
        return const PromocionesScreen();
      case 'Productos':
        return const ProductosScreen();
      case 'Chatbot':
        return const ChatBotScreen();
      case 'Mi pedido':
        return const PedidosCartScreen();
      case 'Información':
        return const InformacionAyudaScreen();
      default:
        return const PromocionesScreen();
    }
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int badge;
  final int delay;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.badge,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.card,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, size: 32, color: color),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              if (badge > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$badge',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
  }
}
