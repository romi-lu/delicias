// Configuración de la API para conectar con el backend de Delicias.
//
// Modos:
// 1) Producción (Railway, HTTPS): define API_BASE_URL sin barra final, ej.
//    API_BASE_URL=https://delicias-api.up.railway.app
// 2) Desarrollo local: API_HOST + API_PORT (http://HOST:PORT/...)

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String _defaultHost = 'localhost';
  static const int _defaultPort = 6002;

  /// URL raíz del backend (https en Railway). Si está vacío, se usa host+puerto HTTP local.
  static String? get _publicBase {
    final v = dotenv.env['API_BASE_URL']?.trim();
    if (v == null || v.isEmpty) return null;
    return v.replaceAll(RegExp(r'/+$'), '');
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
