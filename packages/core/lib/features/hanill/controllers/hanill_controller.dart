import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/features/hanill/models/hanill_model.dart';
import 'package:core/features/hanill/repositories/hanill_repository.dart';

const _systemPrompt = '''
당신은 '한일이'라는 친절한 한국어 여행 AI 어시스턴트입니다.
사용자의 여행 계획, 호텔 추천, 항공권, 현지 정보를 도와줍니다.

여행 일정을 생성해달라는 요청을 받으면, 일반 설명 뒤에 반드시 아래 JSON 블록을 포함하세요.
각 장소의 lat/lng는 실제 정확한 좌표를 입력하세요.

```schedule
{
  "title": "여행 제목",
  "location": "주요 도시명(영문)",
  "startDate": "YYYY-MM-DD",
  "endDate": "YYYY-MM-DD",
  "days": [
    {
      "day": 1,
      "date": "N월 N일",
      "places": [
        {
          "time": "오전 10:00",
          "placeName": "장소명",
          "description": "한 줄 설명",
          "lat": 위도,
          "lng": 경도
        }
      ]
    }
  ]
}
```

일정 생성이 아닌 일반 질문에는 JSON 없이 한국어로만 답하세요.
''';

/// 한일이 AI 채팅 컨트롤러 — 멀티 스레드 대화 관리
class HanillController extends Notifier<HanillState> {
  final _repository = HanillRepository();

  @override
  HanillState build() {
    final firstThread = _makeThread();
    return HanillState(
      threads: [firstThread],
      activeThreadId: firstThread.id,
    );
  }

  // ─── 스레드 관리 ───────────────────────────────────────────

  /// 새 대화 스레드를 생성하고 활성화
  void createNewThread() {
    final thread = _makeThread();
    state = state.copyWith(
      threads: [thread, ...state.threads],
      activeThreadId: thread.id,
    );
  }

  /// 기존 스레드로 전환
  void switchThread(String threadId) {
    final target = state.threads.where((t) => t.id == threadId);
    if (target.isEmpty) {
      return;
    }
    state = state.copyWith(activeThreadId: threadId);
  }

  /// 스레드 삭제 — 마지막 스레드면 새 대화로 대체
  void deleteThread(String threadId) {
    final remaining = state.threads.where((t) => t.id != threadId).toList();

    if (remaining.isEmpty) {
      final fresh = _makeThread();
      state = state.copyWith(
        threads: [fresh],
        activeThreadId: fresh.id,
      );
      return;
    }

    final newActive = state.activeThreadId == threadId
        ? remaining.first.id
        : state.activeThreadId;

    state = state.copyWith(threads: remaining, activeThreadId: newActive);
  }

  // ─── 메시지 전송 ───────────────────────────────────────────

  /// 사용자 메시지를 전송하고 AI 응답을 현재 스레드에 반영
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    final activeId = state.activeThreadId;
    final currentTarget = state.threads.where((t) => t.id == activeId);
    if (currentTarget.isEmpty) {
      return;
    }

    final userMsg = ChatMessage(role: MessageRole.user, content: text.trim());

    // 스레드 제목은 첫 메시지로 자동 설정
    final currentThread = state.activeThread;
    final autoTitle =
        (currentThread != null &&
            currentThread.title == '새 대화' &&
            currentThread.messages.isEmpty)
        ? _truncate(text.trim(), 22)
        : null;

    state = state.copyWith(
      threads: _patchThread(
        activeId,
        (t) => t.copyWith(
          messages: [...t.messages, userMsg],
          title: autoTitle,
        ),
      ),
      isLoading: true,
    );

    try {
      // 방금 추가한 사용자 메시지까지 포함된 현재 스레드 기록 전체 전송
      final history = state.threads
          .firstWhere((t) => t.id == activeId)
          .messages;
      final rawText = await _repository.sendChat(
        systemPrompt: _systemPrompt,
        history: history,
      );

      final aiMsg = ChatMessage(
        role: MessageRole.assistant,
        content: _stripScheduleBlock(rawText),
        generatedSchedule: _parseSchedule(rawText),
      );

      state = state.copyWith(
        threads: _patchThread(
          activeId,
          (t) => t.copyWith(messages: [...t.messages, aiMsg]),
        ),
        isLoading: false,
      );
    } on Exception catch (e) {
      final errMsg = ChatMessage(
        role: MessageRole.assistant,
        content:
            '오류가 발생했어요: $e\napi_proxy 서버가 켜져 있는지, .env의 API_PROXY_BASE_URL이 맞는지 확인해주세요.',
      );
      state = state.copyWith(
        threads: _patchThread(
          activeId,
          (t) => t.copyWith(messages: [...t.messages, errMsg]),
        ),
        isLoading: false,
      );
    }
  }

  // ─── private 헬퍼 ─────────────────────────────────────────

  /// 새 스레드 생성
  ChatThread _makeThread() {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    return ChatThread(
      id: id,
      title: '새 대화',
      messages: const [],
      createdAt: DateTime.now(),
    );
  }

  /// 특정 스레드만 변경한 threads 목록 반환
  List<ChatThread> _patchThread(
    String threadId,
    ChatThread Function(ChatThread) updater,
  ) {
    return state.threads.map((t) => t.id == threadId ? updater(t) : t).toList();
  }

  /// 텍스트 최대 길이 제한 (말줄임표 포함)
  String _truncate(String text, int max) {
    if (text.length <= max) {
      return text;
    }
    return '${text.substring(0, max)}…';
  }

  /// ```schedule...``` 블록 파싱
  GeneratedSchedule? _parseSchedule(String text) {
    final match = RegExp(r'```schedule\s*([\s\S]*?)\s*```').firstMatch(text);
    if (match == null) {
      return null;
    }
    try {
      final json = jsonDecode(match.group(1)!) as Map<String, dynamic>;
      return GeneratedSchedule.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  /// ```schedule...``` 블록 제거
  String _stripScheduleBlock(String text) {
    return text.replaceAll(RegExp(r'```schedule\s*[\s\S]*?\s*```'), '').trim();
  }
}

/// 한일이 컨트롤러 Provider
final hanillControllerProvider =
    NotifierProvider<HanillController, HanillState>(
      HanillController.new,
    );
