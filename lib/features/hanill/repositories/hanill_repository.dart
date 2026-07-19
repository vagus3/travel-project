import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:template/features/hanill/models/hanill_model.dart';

/// NVIDIA NIM(OpenAI 호환 API) 기반 LLM 채팅 Repository
///
/// build.nvidia.com 에서 발급받은 API 키(.env의 NVIDIA_API_KEY)로
/// 오픈소스 LLM을 호출합니다.
class HanillRepository {
  static const _baseUrl = 'https://integrate.api.nvidia.com/v1';

  /// 사용 모델 — 교체 시 이 값만 변경 (예: 'z-ai/glm-5.2')
  static const model = 'deepseek-ai/deepseek-v4-flash';

  /// 시스템 프롬프트와 대화 기록을 보내고 어시스턴트 응답 텍스트를 반환합니다.
  ///
  /// [history]에는 이번에 보낼 사용자 메시지까지 포함되어야 합니다.
  Future<String> sendChat({
    required String systemPrompt,
    required List<ChatMessage> history,
  }) async {
    final apiKey = dotenv.env['NVIDIA_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey.startsWith('여기에')) {
      throw Exception('.env의 NVIDIA_API_KEY가 설정되지 않았습니다.');
    }

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
      for (final m in history)
        {
          'role': m.role == MessageRole.user ? 'user' : 'assistant',
          'content': m.content,
        },
    ];

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 4096,
        // 채팅 응답 속도를 위해 thinking 모드 비활성화
        'chat_template_kwargs': {'thinking': false},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'LLM 호출 실패 (${response.statusCode}): ${response.body}',
      );
    }

    // 한글 깨짐 방지를 위해 bodyBytes를 UTF-8로 직접 디코딩
    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final choices = data['choices'] as List? ?? [];
    if (choices.isEmpty) {
      throw Exception('LLM 응답이 비어 있습니다.');
    }

    final message =
        (choices.first as Map<String, dynamic>)['message']
            as Map<String, dynamic>? ??
        {};
    final content = message['content'] as String? ?? '';
    return _stripThinkBlock(content);
  }

  /// reasoning 모델이 content에 남기는 `<think>` 블록 제거
  String _stripThinkBlock(String text) {
    return text.replaceAll(RegExp(r'<think>[\s\S]*?</think>'), '').trim();
  }
}
