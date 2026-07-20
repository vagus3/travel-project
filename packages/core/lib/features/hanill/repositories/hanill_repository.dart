import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:core/features/hanill/models/hanill_model.dart';

/// 한일이 AI 채팅 Repository
///
/// NVIDIA NIM API 키는 클라이언트가 아니라 `api_proxy` 백엔드가 서버에서만
/// 보관합니다. 이 Repository는 `API_PROXY_BASE_URL`로 요청을 위임할 뿐,
/// 업스트림 LLM 제공자를 직접 알지 못합니다.
class HanillRepository {
  String get _baseUrl =>
      dotenv.env['API_PROXY_BASE_URL'] ?? 'http://localhost:8080';

  /// 시스템 프롬프트와 대화 기록을 보내고 어시스턴트 응답 텍스트를 반환합니다.
  ///
  /// [history]에는 이번에 보낼 사용자 메시지까지 포함되어야 합니다.
  Future<String> sendChat({
    required String systemPrompt,
    required List<ChatMessage> history,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/hanill/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemPrompt': systemPrompt,
        'messages': [
          for (final m in history)
            {
              'role': m.role == MessageRole.user ? 'user' : 'assistant',
              'content': m.content,
            },
        ],
      }),
    );

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception('한일이 응답 실패: ${data['error'] ?? response.body}');
    }

    return data['content'] as String? ?? '';
  }
}
