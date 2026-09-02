import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  
  // List of potential base URLs to try (in order of preference)
  static List<String> get _baseUrlOptions => [
    if (kIsWeb) 'http://localhost:3000',
    'http://192.168.1.200:3000',  // Host machine real IP
    'http://localhost:3000',       // Localhost
    'http://10.0.2.2:3000',       // Android Emulator fallback
  ];
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => true,
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: false,
      logPrint: (obj) => debugPrint('[API] $obj'),
    ));
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      debugPrint('[API SERVICE] POST Error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      debugPrint('[API SERVICE] GET Error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Health check untuk verify connection ke API server
  /// Returns null jika berhasil, error message jika gagal
  Future<String?> healthCheck() async {
    debugPrint('[API SERVICE] Running health check...');
    
    for (final url in _baseUrlOptions) {
      try {
        final response = await Dio().get(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            connectTimeout: const Duration(seconds: 10),
          ),
        );
        
        if (response.statusCode == 200) {
          debugPrint('[API SERVICE] Health check SUCCESS at: $url');
          return null; // Success
        }
      } catch (e) {
        debugPrint('[API SERVICE] Health check failed for $url: $e');
      }
    }
    
    return 'Cannot connect to API server. Tried: ${_baseUrlOptions.join(", ")}';
  }
}
