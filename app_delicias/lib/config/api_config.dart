// Configuración de la API para conectar con el backend de Delicias.
//
// Modos:
// 1) Producción (Railway, HTTPS): API_BASE_URL sin barra final y sin /api (la app añade /api y /uploads).
//    En app_delicias/.env: API_BASE_URL=https://tu-backend.up.railway.app
//    O: flutter run --dart-define=API_BASE_URL=https://tu-backend.up.railway.app
// 2) Desarrollo local: API_HOST + API_PORT (misma WiFi; en móvil físico usa la IP de tu PC, no localhost).

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String _defaultHost = 'localhost';
  static const int _defaultPort = 6002;

  /// Quita comillas, barras finales y un `/api` erróneo al final (evita /api/api).
  static String? _normalizeRoot(String? raw) {
    if (raw == null) return null;
    var v = raw.trim();
    if (v.isEmpty) return null;
    if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'"))) {
      v = v.substring(1, v.length - 1).trim();
    }
    v = v.replaceAll(RegExp(r'/+$'), '');
    if (v.endsWith('/api')) {
      v = v.substring(0, v.length - 4);
      v = v.replaceAll(RegExp(r'/+$'), '');
    }
    return v.isEmpty ? null : v;
  }

  /// URL raíz del backend (https en Railway). Si está vacío, se usa host+puerto HTTP local.
  static String? get _publicBase {
    const fromDefine = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    final fromEnv = fromDefine.trim().isNotEmpty ? fromDefine : dotenv.env['API_BASE_URL'];
    return _normalizeRoot(fromEnv);
  }

  /// Para depuración: qué base usa la app (sin credenciales).
  static void debugLogResolvedBase() {
    if (!kDebugMode) return;
    final root = _publicBase;
    if (root != null) {
      // ignore: avoid_print
      print('[ApiConfig] Railway/producción → $root/api');
    } else {
      // ignore: avoid_print
      print(
        '[ApiConfig] Modo local → http://$host:$port/api '
        '(en móvil real con Railway, define API_BASE_URL en .env y reinicia la app)',
      );
    }
  }

  static String get host {
    final fromEnv = dotenv.env['API_HOST']?.trim();
    final value = (fromEnv != null && fromEnv.isNotEmpty) ? fromEnv : _defaultHost;
    // En Android emulator, "localhost" apunta al propio emulador.
    if (!kIsWeb && Platform.isAndroid && value == 'localhost') return '10.0.2.2';
    return value;
  }

  static int get port {
    final fromEnv = dotenv.env['API_PORT']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return int.tryParse(fromEnv) ?? _defaultPort;
    }
    return _defaultPort;
  }

  static String get baseUrl {
    final root = _publicBase;
    if (root != null) return '$root/api';
    return 'http://$host:$port/api';
  }

  static String get uploadsUrl {
    final root = _publicBase;
    if (root != null) return '$root/uploads';
    return 'http://$host:$port/uploads';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
