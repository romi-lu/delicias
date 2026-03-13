import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage;

  ApiService(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _storage.clearAuth();
        }
        return handler.next(error);
      },
    ));
  }

  void updateToken(String? token) {
    if (token != null) {
      _storage.saveToken(token);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final r = await _dio.post(path, data: data);
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final r = await _dio.get(path, queryParameters: queryParameters);
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    final r = await _dio.put(path, data: data);
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(String path, {Map<String, dynamic>? data}) async {
    final r = await _dio.patch(path, data: data);
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final r = await _dio.delete(path);
    return r.data as Map<String, dynamic>;
  }
}
