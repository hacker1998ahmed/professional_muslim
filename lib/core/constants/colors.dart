import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Islamic Green Theme
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  
  // Secondary Colors - Gold Accent
  static const Color secondary = Color(0xFFFFD700);
  static const Color secondaryLight = Color(0xFFFFE082);
  static const Color secondaryDark = Color(0xFFFFC107);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Prayer Time Colors
  static const Color fajrColor = Color(0xFF3F51B5);
  static const Color dhuhrColor = Color(0xFFFF9800);
  static const Color asrColor = Color(0xFFFF5722);
  static const Color maghribColor = Color(0xFF9C27B0);
  static const Color ishaColor = Color(0xFF673AB7);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color cardShadowLight = Color(0x1A000000);
  static const Color cardShadowDark = Color(0x3A000000);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color dividerLight = Color(0xFFBDBDBD);
  static const Color dividerDark = Color(0xFF616161);
  
  // Icon Colors
  static const Color iconLight = Color(0xFF616161);
  static const Color iconDark = Color(0xFFBDBDBD);
  static const Color iconActive = primary;
  static const Color iconInactive = Color(0xFF9E9E9E);
  
  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color buttonText = Color(0xFFFFFFFF);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xA0000000);
  
  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);
  
  // Special Colors for Islamic Features
  static const Color quranText = Color(0xFF2E7D32);
  static const Color hadithText = Color(0xFF1565C0);
  static const Color duaText = Color(0xFF6A1B9A);
  static const Color azkarText = Color(0xFFD84315);
  
  // Tasbih Colors
  static const Color tasbihActive = Color(0xFF4CAF50);
  static const Color tasbihInactive = Color(0xFFE0E0E0);
  static const Color tasbihCounter = Color(0xFF2E7D32);
  
  // Qibla Compass Colors
  static const Color compassNeedle = Color(0xFFD32F2F);
  static const Color compassBackground = Color(0xFFF5F5F5);
  static const Color compassText = Color(0xFF424242);
  
  // Prayer Times Colors
  static const Color nextPrayer = Color(0xFF4CAF50);
  static const Color currentPrayer = Color(0xFFFF9800);
  static const Color passedPrayer = Color(0xFF9E9E9E);
  
  // Fasting Tracker Colors
  static const Color fastingDay = Color(0xFF4CAF50);
  static const Color nonFastingDay = Color(0xFFE0E0E0);
  static const Color todayFasting = Color(0xFF2E7D32);
  
  // Zakat Calculator Colors
  static const Color zakatAmount = Color(0xFF4CAF50);
  static const Color totalWealth = Color(0xFF2196F3);
  static const Color nisabAmount = Color(0xFFFF9800);
  
  // Color Schemes
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Color(0xFFFFFFFF),
    secondary: secondary,
    onSecondary: Color(0xFF000000),
    error: error,
    onError: Color(0xFFFFFFFF),
    surface: surfaceLight,
    onSurface: textPrimary,
  );
  
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: Color(0xFF000000),
    secondary: secondary,
    onSecondary: Color(0xFF000000),
    error: error,
    onError: Color(0xFFFFFFFF),
    surface: surfaceDark,
    onSurface: textLight,

  );
  
  // Helper Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }
  
  static List<Color> generateShades(Color baseColor, int count) {
    List<Color> shades = [];
    for (int i = 0; i < count; i++) {
      double factor = (i + 1) / count;
      shades.add(Color.lerp(baseColor, Colors.white, 1 - factor) ?? baseColor);
    }
    return shades;
  }
}
