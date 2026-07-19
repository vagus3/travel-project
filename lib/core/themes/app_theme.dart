import 'package:flutter/material.dart';
import 'package:template/core/themes/app_colors.dart';

/// 앱 전체에서 사용되는 테마 설정
class AppTheme {
  /// 라이트 모드 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF004AAD),
        secondary: Color(0xFF03DAC6),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF111827),
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
    );
  }

  /// 다크 모드 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3D8BFF),
        secondary: Color(0xFF26C6DA),
      ),
      scaffoldBackgroundColor: const Color(0xFF121418),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E2429),
        foregroundColor: Color(0xFFE0E0E0),
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.dark,
      ],
    );
  }
}
