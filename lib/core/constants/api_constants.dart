import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  // === API BASE URL CONFIGURATION ===
  // For Web: Use localhost:3000
  // For Android Emulator: 10.0.2.2 refers to host machine
  // For Physical Device: Use machine LAN IP (192.168.x.x)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://192.168.1.200:3000';
  }
  
  // OPTION 2: Using Android Emulator special alias (only for emulator)
  // static const String baseUrl = 'http://10.0.2.2:3000';

  static const String loginEndpoint = '/api/login';
  static const String healthEndpoint = '/';

  // Timeout configuration untuk accommodate scraping yang memakan waktu lama (2-3 menit)
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(minutes: 3); // 180 detik
}
