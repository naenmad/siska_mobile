import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// Response wrapper yang include raw data untuk caching
class LoginResponse {
  final ScrapeResponse userData;
  final Map<String, dynamic> rawData;
  
  LoginResponse({required this.userData, required this.rawData});
}

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<LoginResponse> login(String npm, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        data: {'npm': npm, 'password': password},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final userData = ScrapeResponse.fromJson(response.data);
        return LoginResponse(
          userData: userData,
          rawData: response.data,
        );
      } else {
        throw Exception(response.data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final respData = e.response?.data;
        if (respData is Map && respData['message'] != null) {
          throw Exception(respData['message']);
        }
      }

      if (e.toString().contains('LOGIN_FAILED')) {
        throw Exception('NPM atau Password salah!');
      }
      if (e.toString().contains('SCRAPING_IN_PROGRESS')) {
        throw Exception('Server sedang sibuk. Coba lagi dalam beberapa detik.');
      }
      if (e.toString().contains('Connection refused') || e.toString().contains('SocketException')) {
        throw Exception('Tidak dapat terhubung ke server. Pastikan API sudah berjalan.');
      }
      
      // Log the exact internal parsing error before rethrowing
      debugPrint('[AUTH REPOSITORY ERROR] $e');
      rethrow;
    }
  }
}
