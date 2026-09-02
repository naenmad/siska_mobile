import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - UNSIKA Maroon Premium
  static const Color primary = Color(0xFF8B0000); // Dark Maroon
  static const Color primaryLight = Color(0xFFD32F2F); // Vibrant Red
  static const Color primaryDark = Color(0xFF4A0000); // Deep Maroon Black

  // Accent
  static const Color accent = Color(0xFFFF5252);
  static const Color accentLight = Color(0xFFFF8A80);

  // Background - Earthy Dark Maroon (Not Blue!)
  static const Color background = Color(0xFF1A0F0F); // Very Dark Maroon Black
  static const Color surface = Color(0xFF2D1B1B);    // Deep Maroon Surface
  static const Color surfaceLight = Color(0xFF3F2B2B); // Lighter Maroon Surface
  static const Color card = Color(0xFF2D1B1B);

  // Text
  static const Color textPrimary = Color(0xFFFDECEC); // Off-White Rose
  static const Color textSecondary = Color(0xFFD1B7B7); // Pinkish Grey
  static const Color textMuted = Color(0xFF8E7373);   // Muted Rose

  // Status
  static const Color success = Color(0xFF2E7D32); // Forest Green
  static const Color warning = Color(0xFFFBC02D);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFFD32F2F);

  // Gradient - Premium Maroon
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B0000), Color(0xFF4A0000)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1B1B), Color(0xFF1A0F0F)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB71C1C), Color(0xFFFF5252)],
  );
}
