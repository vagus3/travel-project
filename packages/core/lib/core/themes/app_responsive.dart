import 'package:flutter/material.dart';

/// BuildContext 반응형 헬퍼 확장
///
/// 화면 너비 기준으로 phone(< 600) / tablet(≥ 600)을 구분하고
/// 적응형 여백·크기 값을 제공합니다.
extension AppResponsive on BuildContext {
  /// 현재 화면 너비
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// 현재 화면 높이
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// 태블릿 여부 (너비 600px 이상)
  bool get isTablet => screenWidth >= 600;

  /// 화면 좌우 기본 패딩 — phone: 16, tablet: 32
  double get hPad => isTablet ? 32.0 : 16.0;

  /// 카드 모서리 반경 — phone: 16, tablet: 20
  double get cardRadius => isTablet ? 20.0 : 16.0;

  /// 섹션 간 세로 간격 — phone: 24, tablet: 32
  double get sectionGap => isTablet ? 32.0 : 24.0;

  /// 본문 폰트 크기 — phone: 14, tablet: 16
  double get bodyFontSize => isTablet ? 16.0 : 14.0;

  /// 제목 폰트 크기 — phone: 18, tablet: 22
  double get titleFontSize => isTablet ? 22.0 : 18.0;
}
