import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  late SharedPreferences _prefs;
  bool _cacheInitialized = false;

  AuthProvider(this._repository);

  // Cache keys
  static const String _npmKey = 'cached_npm';
  static const String _passwordKey = 'cached_password';
  static const String _userDataKey = 'cached_user_data';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ScrapeResponse? _userData;
  ScrapeResponse? get userData => _userData;

  bool get isAuthenticated => _userData != null;

  // Ensure SharedPreferences is initialized
  Future<void> _ensureCacheInitialized() async {
    if (!_cacheInitialized) {
      try {
        _prefs = await SharedPreferences.getInstance();
        _cacheInitialized = true;
        debugPrint('[AUTH PROVIDER] SharedPreferences initialized');
      } catch (e) {
        debugPrint('[AUTH PROVIDER] Error initializing SharedPreferences: $e');
      }
    }
  }

  // Load cached user data - PRIORITY: load dari cache dulu, bukan API
  Future<bool> loadCachedUser() async {
    try {
      await _ensureCacheInitialized();
      
      // STEP 1: Try load data dari cache JSON (instant, no API)
      final userDataJson = _prefs.getString(_userDataKey);
      if (userDataJson != null && userDataJson.isNotEmpty) {
        try {
          final jsonData = jsonDecode(userDataJson) as Map<String, dynamic>;
          _userData = ScrapeResponse.fromJson(jsonData);
          debugPrint('[AUTH PROVIDER] Loaded user data dari cache (instant load)');
          notifyListeners();
          return true;
        } catch (e) {
          debugPrint('[AUTH PROVIDER] Error parsing cached user data: $e');
          // If cache is corrupted, try login with credentials
        }
      }
      
      // STEP 2: If no cache, try login dengan cached credentials
      final npm = _prefs.getString(_npmKey);
      final password = _prefs.getString(_passwordKey);
      
      if (npm != null && password != null && npm.isNotEmpty && password.isNotEmpty) {
        debugPrint('[AUTH PROVIDER] Cache kosong, attempting login dengan cached credentials...');
        return await login(npm, password);
      }
    } catch (e) {
      debugPrint('[AUTH PROVIDER] Error loading cached user: $e');
    }
    return false;
  }

  // Save credentials dan full data JSON ke cache
  Future<void> _saveCachedCredentials(String npm, String password, Map<String, dynamic> rawData) async {
    try {
      await _ensureCacheInitialized();
      
      // Save credentials
      await _prefs.setString(_npmKey, npm);
      await _prefs.setString(_passwordKey, password);
      
      // Save raw API response JSON (untuk instant load saat startup)
      final userDataJson = jsonEncode(rawData);
      await _prefs.setString(_userDataKey, userDataJson);
      
      debugPrint('[AUTH PROVIDER] Credentials & user data cached successfully');
    } catch (e) {
      debugPrint('[AUTH PROVIDER] Error saving cached data: $e');
    }
  }
  
  // Save hanya data (tanpa credentials) - digunakan saat refresh data
  Future<void> _saveUserDataCache(Map<String, dynamic> rawData) async {
    try {
      await _ensureCacheInitialized();
      final userDataJson = jsonEncode(rawData);
      await _prefs.setString(_userDataKey, userDataJson);
      debugPrint('[AUTH PROVIDER] User data cache updated');
    } catch (e) {
      debugPrint('[AUTH PROVIDER] Error updating user data cache: $e');
    }
  }

  // Clear cached data saat logout
  Future<void> _clearCache() async {
    try {
      await _ensureCacheInitialized();
      await _prefs.remove(_npmKey);
      await _prefs.remove(_passwordKey);
      await _prefs.remove(_userDataKey);
      debugPrint('[AUTH PROVIDER] Cache cleared');
    } catch (e) {
      debugPrint('[AUTH PROVIDER] Error clearing cache: $e');
    }
  }

  Future<bool> login(String npm, String password) async {
    _setLoading(true);
    _clearError();

    try {
      debugPrint('[AUTH PROVIDER] Attempting login for: $npm');
      
      final loginResponse = await _repository.login(npm, password);
      _userData = loginResponse.userData;
      
      // Save credentials & full data ke cache
      await _saveCachedCredentials(npm, password, loginResponse.rawData);
      
      _setLoading(false);
      debugPrint('[AUTH PROVIDER] Login successful & cache updated');
      return true;
    } catch (e) {
      _setLoading(false);
      final errorMsg = e.toString();
      _errorMessage = _parseError(errorMsg);
      debugPrint('[AUTH PROVIDER] Login failed: $errorMsg');
      notifyListeners();
      return false;
    }
  }
  
  // Refresh user data dari API (untuk manual update nanti di settings page)
  Future<bool> refreshUserData() async {
    try {
      await _ensureCacheInitialized();
      
      final npm = _prefs.getString(_npmKey);
      final password = _prefs.getString(_passwordKey);
      
      if (npm == null || password == null) {
        throw Exception('No cached credentials found');
      }
      
      _setLoading(true);
      _clearError();
      
      debugPrint('[AUTH PROVIDER] Refreshing user data from API...');
      final loginResponse = await _repository.login(npm, password);
      _userData = loginResponse.userData;
      
      // Update cache dengan data terbaru
      await _saveUserDataCache(loginResponse.rawData);
      
      _setLoading(false);
      debugPrint('[AUTH PROVIDER] User data refreshed successfully');
      return true;
    } catch (e) {
      _setLoading(false);
      final errorMsg = e.toString();
      _errorMessage = _parseError(errorMsg);
      debugPrint('[AUTH PROVIDER] Refresh failed: $errorMsg');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _userData = null;
    _clearError();
    _clearCache(); // Hapus cached credentials saat logout
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _parseError(String errorMsg) {
    // Timeout error
    if (errorMsg.contains('receive timeout') || errorMsg.contains('receiveTimeout')) {
      return 'Koneksi lambat atau server tidak merespons. API server perlu 2-3 menit untuk scraping. Pastikan server sudah jalan di port 3000.';
    }
    if (errorMsg.contains('connection') || errorMsg.contains('Connection refused')) {
      return 'Tidak bisa connect ke API server. Pastikan server sedang jalan di localhost:3000';
    }
    if (errorMsg.contains('LOGIN_FAILED')) {
      return 'Email/NPM atau Password salah. Cek kembali!';
    }
    if (errorMsg.contains('MISSING_CREDENTIALS')) {
      return 'Email/NPM dan Password harus diisi!';
    }
    if (errorMsg.contains('SCRAPING_IN_PROGRESS')) {
      return 'Sedang ada request lain. Tunggu beberapa saat dan coba lagi.';
    }
    
    if (errorMsg.contains('Exception:')) {
      return errorMsg.split('Exception: ').last;
    }
    return 'Terjadi kesalahan. Coba lagi nanti.';
  }
}
