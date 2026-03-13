import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyToken = 'auth_token';
  static const _keyUserType = 'user_type';
  static const _keyUserId = 'user_id';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  String? getToken() => _prefs.getString(_keyToken);

  Future<void> saveUserType(String type) async {
    await _prefs.setString(_keyUserType, type);
  }

  String? getUserType() => _prefs.getString(_keyUserType);

  Future<void> saveUserId(int id) async {
    await _prefs.setInt(_keyUserId, id);
  }

  int? getUserId() => _prefs.getInt(_keyUserId);

  Future<void> clearAuth() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserType);
    await _prefs.remove(_keyUserId);
  }

  bool get isLoggedIn {
    final t = getToken();
    return t != null && t.isNotEmpty;
  }
}
