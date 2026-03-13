/// Configuración de la API para conectar con el backend de Delicias.
/// En producción, usar variables de entorno o flavors.
class ApiConfig {
  static const String baseUrl = 'http://localhost:6002/api';
  static const String uploadsUrl = 'http://localhost:6002/uploads';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
