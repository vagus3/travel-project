/// 채팅 메시지 발신자 역할
enum MessageRole {
  /// 사용자 메시지
  user,

  /// AI 어시스턴트 메시지
  assistant,
}

/// 채팅 메시지 모델
class ChatMessage {
  /// [ChatMessage] 생성자
  const ChatMessage({
    required this.role,
    required this.content,
    this.generatedSchedule,
  });

  /// 메시지 발신자 역할
  final MessageRole role;

  /// 메시지 텍스트 내용
  final String content;

  /// AI가 생성한 일정 (일정 요청 응답 시에만 존재)
  final GeneratedSchedule? generatedSchedule;
}

/// 대화 스레드 — 하나의 독립된 대화 세션
class ChatThread {
  /// [ChatThread] 생성자
  const ChatThread({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });

  /// 스레드 고유 ID
  final String id;

  /// 스레드 제목 (첫 메시지 텍스트 기반)
  final String title;

  /// 메시지 목록
  final List<ChatMessage> messages;

  /// 생성 시각
  final DateTime createdAt;

  /// 상태 복사
  ChatThread copyWith({String? title, List<ChatMessage>? messages}) {
    return ChatThread(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt,
    );
  }
}

/// 한일이 화면 전체 상태
class HanillState {
  /// [HanillState] 생성자
  const HanillState({
    this.threads = const [],
    this.activeThreadId = '',
    this.isLoading = false,
  });

  /// 저장된 대화 스레드 목록
  final List<ChatThread> threads;

  /// 현재 활성 스레드 ID
  final String activeThreadId;

  /// AI 응답 대기 중 여부
  final bool isLoading;

  /// 현재 활성 스레드
  ChatThread? get activeThread {
    final matches = threads.where((t) => t.id == activeThreadId);
    return matches.isEmpty ? null : matches.first;
  }

  /// 현재 스레드의 메시지 목록
  List<ChatMessage> get currentMessages => activeThread?.messages ?? [];

  /// 상태 복사
  HanillState copyWith({
    List<ChatThread>? threads,
    String? activeThreadId,
    bool? isLoading,
  }) {
    return HanillState(
      threads: threads ?? this.threads,
      activeThreadId: activeThreadId ?? this.activeThreadId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// AI가 생성한 여행 일정 전체
class GeneratedSchedule {
  /// [GeneratedSchedule] 생성자
  const GeneratedSchedule({
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  /// AI 응답의 JSON 블록으로부터 파싱
  factory GeneratedSchedule.fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'] as List? ?? [];
    return GeneratedSchedule(
      title: json['title'] as String? ?? '여행 일정',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      days: rawDays
          .map((d) => ScheduleDay.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 일정 제목
  final String title;

  /// 주요 여행지 도시명
  final String location;

  /// 여행 시작일 (YYYY-MM-DD)
  final String startDate;

  /// 여행 종료일 (YYYY-MM-DD)
  final String endDate;

  /// 날짜별 일정 목록
  final List<ScheduleDay> days;
}

/// 하루 일정
class ScheduleDay {
  /// [ScheduleDay] 생성자
  const ScheduleDay({
    required this.day,
    required this.date,
    required this.places,
  });

  /// [ScheduleDay] JSON 파싱 생성자
  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    final rawPlaces = json['places'] as List? ?? [];
    return ScheduleDay(
      day: (json['day'] as num?)?.toInt() ?? 1,
      date: json['date'] as String? ?? '',
      places: rawPlaces
          .map((p) => SchedulePlace.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Day 번호 (1, 2, 3...)
  final int day;

  /// 날짜 문자열 (예: 5월 15일)
  final String date;

  /// 해당 날의 장소 목록
  final List<SchedulePlace> places;
}

/// 일정 내 개별 장소
class SchedulePlace {
  /// [SchedulePlace] 생성자
  const SchedulePlace({
    required this.time,
    required this.placeName,
    required this.description,
    required this.lat,
    required this.lng,
  });

  /// [SchedulePlace] JSON 파싱 생성자
  factory SchedulePlace.fromJson(Map<String, dynamic> json) {
    return SchedulePlace(
      time: json['time'] as String? ?? '',
      placeName: json['placeName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// 방문 시간 (예: 오전 10:00)
  final String time;

  /// 장소명
  final String placeName;

  /// 장소 설명
  final String description;

  /// 위도
  final double lat;

  /// 경도
  final double lng;
}
