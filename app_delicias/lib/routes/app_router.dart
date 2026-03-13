import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/admin_login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/products/products_screen.dart';
import '../screens/products/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/admin/admin_home_screen.dart';

class AppRouter {
  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(StorageService storage) {
    final isLoggedIn = storage.getToken() != null && storage.getToken()!.isNotEmpty;
    final isAdmin = storage.getUserType() == 'admin';

    return GoRouter(
      navigatorKey: _rootKey,
      initialLocation: isLoggedIn ? (isAdmin ? '/admin' : '/home') : '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/admin/login',
          builder: (_, __) => const AdminLoginScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellKey,
          builder: (_, __, child) => MainScaffold(child: child),
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (_, state) => const NoTransitionPage(child: HomeScreen()),
            ),
            GoRoute(
              path: '/products',
              pageBuilder: (_, state) => const NoTransitionPage(child: ProductsScreen()),
            ),
            GoRoute(
              path: '/products/:id',
              builder: (_, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return ProductDetailScreen(productId: id);
              },
            ),
            GoRoute(
              path: '/cart',
              pageBuilder: (_, state) => const NoTransitionPage(child: CartScreen()),
            ),
            GoRoute(
              path: '/orders',
              pageBuilder: (_, state) => const NoTransitionPage(child: OrdersScreen()),
            ),
            GoRoute(
              path: '/orders/:id',
              builder: (_, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return OrderDetailScreen(orderId: id);
              },
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (_, state) => const NoTransitionPage(child: ProfileScreen()),
            ),
            GoRoute(
              path: '/help',
              pageBuilder: (_, state) => const NoTransitionPage(child: HelpScreen()),
            ),
          ],
        ),
        GoRoute(
          path: '/admin',
          builder: (_, __) => const AdminHomeScreen(),
        ),
      ],
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (i) => _onItemTapped(context, i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFb87333),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'Tienda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.startsWith('/home')) return 0;
    if (loc.startsWith('/products')) return 1;
    if (loc.startsWith('/cart')) return 2;
    if (loc.startsWith('/orders')) return 3;
    if (loc.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/products');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/orders');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
