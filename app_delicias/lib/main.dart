import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/api_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/products_service.dart';
import 'services/orders_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('No se pudo cargar .env (crea app_delicias/.env desde .env.example): $e');
      debugPrint('$st');
    }
  }
  ApiConfig.debugLogResolvedBase();
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);
  final api = ApiService(storage);
  runApp(DeliciasApp(storage: storage, api: api));
}

class DeliciasApp extends StatelessWidget {
  final StorageService storage;
  final ApiService api;

  const DeliciasApp({super.key, required this.storage, required this.api});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final auth = AuthProvider(storage);
          auth.loadUserIfLoggedIn();
          return auth;
        }),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider<ProductsService>(create: (_) => ProductsService(api)),
        Provider<OrdersService>(create: (_) => OrdersService(api)),
      ],
      child: MaterialApp(
        title: 'Delicias del Centro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn) {
      return const AppShell();
    }
    return const LoginScreen();
  }
}
