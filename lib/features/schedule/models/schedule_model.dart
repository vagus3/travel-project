/// 일정 계획 모델
class PlanSchedule {
  /// [PlanSchedule] 생성자
  const PlanSchedule({
    required this.location,
    required this.date,
    required this.title,
  });

  /// 장소 이름
  final String location;

  /// 날짜
  final String date;

  /// 일정 제목
  final String title;
}

/// 일정 요약 모델 (목록 카드용)
class ScheduleSummary {
  /// [ScheduleSummary] 생성자
  ScheduleSummary({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.imageUrl,
    this.location = '',
    this.details = const [],
  });

  /// 일정 고유 ID
  final String id;

  /// 일정 제목
  final String title;

  /// 날짜 범위 (예: 2025.05.15 ~ 2025.05.18)
  final String dateRange;

  /// 대표 이미지 URL
  final String imageUrl;

  /// 주요 여행지 도시명
  final String location;

  /// 상세 일정 목록
  final List<ScheduleDetail> details;
}

/// 일정 상세 모델 (타임라인 아이템 + 지도 마커)
class ScheduleDetail {
  /// [ScheduleDetail] 생성자
  const ScheduleDetail({
    required this.day,
    required this.time,
    required this.placeName,
    required this.description,
    required this.imageUrl,
    this.lat = 0.0,
    this.lng = 0.0,
  });

  /// Day 번호 (1, 2, 3…)
  final int day;

  /// 방문 시간
  final String time;

  /// 장소명
  final String placeName;

  /// 장소 설명
  final String description;

  /// 장소 이미지 URL
  final String imageUrl;

  /// 위도
  final double lat;

  /// 경도
  final double lng;
}
