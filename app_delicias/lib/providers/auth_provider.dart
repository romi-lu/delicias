import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _user;
  bool _isAdmin = false;
  bool _loading = false;
  String? _error;

  final AuthService _authService;

  AuthProvider(StorageService storage)
      : _authService = AuthService(ApiService(storage), storage),
        _storage = storage {
    _isAdmin = storage.getUserType() == 'admin';
  }

  final StorageService _storage;

  Usuario? get user => _user;

  Future<void> loadUserIfLoggedIn() async {
    if (!_authService.isLoggedIn) return;
    if (_user != null) return;
    _user = await _authService.verifyAndGetUser();
    _isAdmin = _storage.getUserType() == 'admin';
    notifyListeners();
  }
  bool get isAdmin => _isAdmin;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _authService.isLoggedIn;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.login(email, password);
    _loading = false;

    if (result.success && result.user != null) {
      _user = result.user;
      _isAdmin = false;
      notifyListeners();
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    String? telefono,
    String? direccion,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.register(
      nombre: nombre,
      apellido: apellido,
      email: email,
      password: password,
      telefono: telefono,
      direccion: direccion,
    );
    _loading = false;

    if (result.success && result.user != null) {
      _user = result.user;
      _isAdmin = false;
      notifyListeners();
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<bool> adminLogin(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.adminLogin(email, password);
    _loading = false;

    if (result.success) {
      _user = Usuario(
        id: result.id!,
        nombre: result.nombre!,
        apellido: '',
        email: result.email!,
      );
      _isAdmin = true;
      notifyListeners();
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAdmin = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
