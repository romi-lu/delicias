import 'package:dio/dio.dart';
import '../models/usuario.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api;
  final StorageService _storage;

  AuthService(this._api, this._storage);

  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await _api.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (res['statusCode'] == 200) {
        final token = res['token'] as String;
        final userJson = res['user'] as Map<String, dynamic>;
        _storage.saveToken(token);
        _storage.saveUserType('usuario');
        _storage.saveUserId(userJson['id'] as int);
        return AuthResult.success(
          user: Usuario.fromJson(userJson),
          token: token,
        );
      }
      return AuthResult.failure(res['message'] as String? ?? 'Error al iniciar sesión');
    } catch (e) {
      return AuthResult.failure(_parseError(e));
    }
  }

  Future<AuthResult> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    String? telefono,
    String? direccion,
  }) async {
    try {
      final res = await _api.post('/auth/register', data: {
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password,
        if (telefono != null && telefono.isNotEmpty) 'telefono': telefono,
        if (direccion != null && direccion.isNotEmpty) 'direccion': direccion,
      });
      if (res['statusCode'] == 201) {
        final token = res['token'] as String;
        final userJson = res['user'] as Map<String, dynamic>;
        _storage.saveToken(token);
        _storage.saveUserType('usuario');
        _storage.saveUserId(userJson['id'] as int);
        return AuthResult.success(
          user: Usuario.fromJson(userJson),
          token: token,
        );
      }
      return AuthResult.failure(res['message'] as String? ?? 'Error al registrarse');
    } catch (e) {
      return AuthResult.failure(_parseError(e));
    }
  }

  Future<AdminAuthResult> adminLogin(String email, String password) async {
    try {
      final res = await _api.post('/auth/admin/login', data: {
        'email': email,
        'password': password,
      });
      if (res['statusCode'] == 200) {
        final token = res['token'] as String;
        final adminJson = res['admin'] as Map<String, dynamic>;
        _storage.saveToken(token);
        _storage.saveUserType('admin');
        _storage.saveUserId(adminJson['id'] as int);
        return AdminAuthResult.success(
          id: adminJson['id'] as int,
          nombre: adminJson['nombre'] as String,
          email: adminJson['email'] as String,
          rol: adminJson['rol'] as String? ?? 'admin',
          token: token,
        );
      }
      return AdminAuthResult.failure(res['message'] as String? ?? 'Error al iniciar sesión');
    } catch (e) {
      return AdminAuthResult.failure(_parseError(e));
    }
  }

  Future<void> logout() async {
    await _storage.clearAuth();
  }

  Future<Usuario?> verifyAndGetUser() async {
    if (!_storage.isLoggedIn) return null;
    try {
      final res = await _api.get('/auth/verify');
      if (res['statusCode'] == 200) {
        if (res['tipo'] == 'admin') {
          final admin = res['admin'] as Map<String, dynamic>?;
          if (admin != null) {
            return Usuario(id: admin['id'] as int, nombre: admin['nombre'] as String, apellido: '', email: admin['email'] as String);
          }
        } else {
          final user = res['user'] as Map<String, dynamic>?;
          if (user != null) return Usuario.fromJson(user);
        }
      }
    } catch (_) {}
    return null;
  }

  bool get isLoggedIn => _storage.isLoggedIn;
  bool get isAdmin => _storage.getUserType() == 'admin';

  String _parseError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return 'Sin conexión al servidor. En app_delicias/.env define API_BASE_URL=https://tu-backend.up.railway.app (sin /api) y reinicia la app.';
      }
      final code = e.response?.statusCode;
      if (code == 401) return 'Email o contraseña incorrectos';
      if (code == 403) return 'Acceso denegado';
      final data = e.response?.data;
      if (data is Map) {
        final m = data['message'] ?? data['error'];
        if (m is String && m.isNotEmpty) return m;
      }
      if (code != null) return 'Error del servidor ($code). Intenta de nuevo.';
    }
    final s = e.toString();
    if (s.contains('SocketException') || s.contains('Connection') || s.contains('XMLHttpRequest')) {
      return 'No se pudo conectar. Revisa API_BASE_URL en .env para apuntar a Railway y reinicia.';
    }
    if (s.contains('401')) return 'Email o contraseña incorrectos';
    return 'Ha ocurrido un error. Intenta de nuevo.';
  }
}

class AuthResult {
  final bool success;
  final Usuario? user;
  final String? token;
  final String? error;

  AuthResult._({this.success = false, this.user, this.token, this.error});

  factory AuthResult.success({required Usuario user, required String token}) {
    return AuthResult._(success: true, user: user, token: token);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(success: false, error: error);
  }
}

class AdminAuthResult {
  final bool success;
  final int? id;
  final String? nombre;
  final String? email;
  final String? rol;
  final String? token;
  final String? error;

  AdminAuthResult._({this.success = false, this.id, this.nombre, this.email, this.rol, this.token, this.error});

  factory AdminAuthResult.success({
    required int id,
    required String nombre,
    required String email,
    required String rol,
    required String token,
  }) {
    return AdminAuthResult._(success: true, id: id, nombre: nombre, email: email, rol: rol, token: token);
  }

  factory AdminAuthResult.failure(String error) {
    return AdminAuthResult._(success: false, error: error);
  }
}
