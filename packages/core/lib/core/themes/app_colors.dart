import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 색상을 정의하는 ThemeExtension
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// 생성자
  const AppColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.secondary,
    required this.highlight,
    required this.error,
    required this.success,
    required this.warning,
  });

  /// 페이지 스캐폴드 배경색
  final Color background;

  /// 카드·패널 배경색 (surface)
  final Color surface;

  /// 구분선·테두리 색상
  final Color border;

  /// 기본 텍스트 색상 (제목, 강조)
  final Color textPrimary;

  /// 보조 텍스트 색상 (레이블, 메타)
  final Color textSecondary;

  /// 흐린 텍스트 색상 (힌트, 플레이스홀더)
  final Color textMuted;

  /// 브랜드 주요 색상
  final Color primary;

  /// 보조 강조 색상
  final Color secondary;

  /// 포인트 색상 (핑크 액센트)
  final Color highlight;

  /// 오류 상태 표시 색상
  final Color error;

  /// 성공 상태 표시 색상
  final Color success;

  /// 경고 상태 표시 색상
  final Color warning;

  /// 밝은 테마용 색상 정의
  static const light = AppColors(
    background: Color(0xFFF8F9FA),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE5E7EB),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF617C89),
    textMuted: Color(0xFF9CA3AF),
    primary: Color(0xFF004AAD),
    secondary: Color(0xFF03DAC6),
    highlight: Color(0xFFEE2B5B),
    error: Color(0xFFB00020),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
  );

  /// 다크 테마용 색상 정의
  static const dark = AppColors(
    background: Color(0xFF121418),
    surface: Color(0xFF1E2429),
    border: Color(0xFF2D3748),
    textPrimary: Color(0xFFE0E0E0),
    textSecondary: Color(0xFF9CA3AF),
    textMuted: Color(0xFF6B7280),
    primary: Color(0xFF3D8BFF),
    secondary: Color(0xFF26C6DA),
    highlight: Color(0xFFFF6B8A),
    error: Color(0xFFCF6679),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFD54F),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? secondary,
    Color? highlight,
    Color? error,
    Color? success,
    Color? warning,
  }) => AppColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    border: border ?? this.border,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    highlight: highlight ?? this.highlight,
    error: error ?? this.error,
    success: success ?? this.success,
    warning: warning ?? this.warning,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

/// BuildContext 확장을 통해 AppColors에 쉽게 접근합니다.
extension AppColorsExtension on BuildContext {
  /// AppColors getter
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
