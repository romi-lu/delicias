// Configuración de la API para conectar con el backend de Delicias.
// Origen (por prioridad): .env → --dart-define → valor por defecto.

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String _defaultHost = 'localhost';
  static const int _defaultPort = 6002;

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

  static String get baseUrl => 'http://$host:$port/api';
  static String get uploadsUrl => 'http://$host:$port/uploads';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
