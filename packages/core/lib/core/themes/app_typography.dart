import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 텍스트 스타일을 정의하는 클래스
class AppTypography {
  /// 큰 제목 스타일 (32px, 일반)
  static const heading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    fontFamily: 'Noto Sans KR',
  );

  /// 중간 제목 스타일 (20px, 볼드)
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Noto Sans KR',
  );

  /// 화면 상단바·섹션 제목 스타일 (18px, 볼드)
  static const subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Noto Sans KR',
  );

  /// 일반 본문 스타일 (16px, 일반)
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Noto Sans KR',
  );

  /// 강조 본문 스타일 (16px, 볼드)
  static const bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Noto Sans KR',
  );

  /// 작은 텍스트 스타일 (14px, 일반)
  static const caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Noto Sans KR',
  );

  /// 레이블 스타일 (13px, 중간 굵기) — 가격·날짜 등 짧은 메타 텍스트
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: 'Noto Sans KR',
  );

  /// 작은 텍스트 스타일 (12px, 일반) — 캡션 하위 메타 정보
  static const small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Noto Sans KR',
  );

  /// 가장 작은 텍스트 스타일 (11px, 일반) — 뱃지·타임스탬프
  static const micro = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontFamily: 'Noto Sans KR',
  );
}
