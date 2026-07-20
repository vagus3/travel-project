import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// 로컬 실행 시 .env 를 읽고, 컨테이너/K8s 환경에서는 실제 환경변수를 그대로 사용합니다.
late final DotEnv _env;

/// 한일이(AI 채팅)에 사용할 NVIDIA NIM 모델
/// 교체 시 이 값만 변경 (예: 'z-ai/glm-5.2')
const _hanillModel = 'deepseek-ai/deepseek-v4-flash';

void main(List<String> args) async {
  _env = DotEnv(includePlatformEnvironment: true);
  if (File('.env').existsSync()) {
    _env.load();
  }

  // `FROM scratch` 컨테이너에는 curl/wget이 없으므로, 같은 실행 파일을
  // `--healthcheck` 모드로 재사용해 Docker Compose 헬스체크에 활용합니다.
  if (args.contains('--healthcheck')) {
    await _selfHealthcheck();
    return;
  }

  final router = Router()
    ..get('/healthz', (Request req) => Response.ok('ok'))
    ..post('/api/hanill/chat', _hanillChatHandler)
    ..get('/api/weather/current', _weatherCurrentHandler)
    ..get('/api/weather/forecast', _weatherForecastHandler)
    ..get('/api/news', _newsHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  final port = int.tryParse(_env['PORT'] ?? '') ?? 8080;
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  // ignore: avoid_print
  print('api_proxy listening on :${server.port}');
}

/// `--healthcheck` 모드: 자기 자신의 `/healthz`에 HTTP GET을 보내 exit code로 결과를 알립니다.
Future<void> _selfHealthcheck() async {
  final port = int.tryParse(_env['PORT'] ?? '') ?? 8080;
  final client = HttpClient();
  try {
    final request = await client
        .getUrl(Uri.parse('http://localhost:$port/healthz'))
        .timeout(const Duration(seconds: 2));
    final response = await request.close().timeout(const Duration(seconds: 2));
    exit(response.statusCode == 200 ? 0 : 1);
  } on Exception {
    exit(1);
  } finally {
    client.close(force: true);
  }
}

// ─── CORS ───────────────────────────────────────────────────────────
// 로컬 개발 환경 기준 permissive 설정입니다. 운영 배포 시 허용 origin을
// 웹 앱 도메인으로 좁히는 것을 권장합니다.

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await innerHandler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

// ─── 공통 헬퍼 ──────────────────────────────────────────────────────

Response _jsonResponse(int statusCode, Object body) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}

Response _upstreamError(Object error) {
  return _jsonResponse(502, {'error': '업스트림 API 호출 실패: $error'});
}

// ─── 한일이 (NVIDIA NIM) ────────────────────────────────────────────

Future<Response> _hanillChatHandler(Request request) async {
  final apiKey = _env['NVIDIA_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    return _jsonResponse(500, {'error': '서버에 NVIDIA_API_KEY가 설정되지 않았습니다.'});
  }

  final Map<String, dynamic> payload;
  try {
    payload = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
  } on FormatException {
    return _jsonResponse(400, {'error': '잘못된 요청 본문입니다.'});
  }

  final systemPrompt = payload['systemPrompt'] as String? ?? '';
  final rawMessages = payload['messages'] as List? ?? [];
  final messages = <Map<String, String>>[
    if (systemPrompt.isNotEmpty) {'role': 'system', 'content': systemPrompt},
    for (final m in rawMessages)
      {
        'role': (m as Map)['role'] as String? ?? 'user',
        'content': m['content'] as String? ?? '',
      },
  ];

  try {
    final response = await http.post(
      Uri.parse('https://integrate.api.nvidia.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _hanillModel,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 4096,
        'chat_template_kwargs': {'thinking': false},
      }),
    );

    if (response.statusCode != 200) {
      return _jsonResponse(response.statusCode, {
        'error': 'NVIDIA NIM 호출 실패: ${response.body}',
      });
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final choices = data['choices'] as List? ?? [];
    if (choices.isEmpty) {
      return _jsonResponse(502, {'error': 'LLM 응답이 비어 있습니다.'});
    }
    final message =
        (choices.first as Map<String, dynamic>)['message']
            as Map<String, dynamic>? ??
        {};
    final rawContent = message['content'] as String? ?? '';
    final content = rawContent
        .replaceAll(RegExp(r'<think>[\s\S]*?</think>'), '')
        .trim();

    return _jsonResponse(200, {'content': content});
  } on Exception catch (e) {
    return _upstreamError(e);
  }
}

// ─── 날씨 (OpenWeatherMap) ──────────────────────────────────────────

Future<Response> _weatherCurrentHandler(Request request) async {
  final apiKey = _env['OPENWEATHER_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    return _jsonResponse(500, {
      'error': '서버에 OPENWEATHER_API_KEY가 설정되지 않았습니다.',
    });
  }
  final city = request.url.queryParameters['city'];
  if (city == null || city.isEmpty) {
    return _jsonResponse(400, {'error': 'city 쿼리 파라미터가 필요합니다.'});
  }

  final uri = Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather'
    '?q=$city&appid=$apiKey&units=metric&lang=kr',
  );
  try {
    final response = await http.get(uri);
    return Response(
      response.statusCode,
      body: response.bodyBytes,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  } on Exception catch (e) {
    return _upstreamError(e);
  }
}

Future<Response> _weatherForecastHandler(Request request) async {
  final apiKey = _env['OPENWEATHER_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    return _jsonResponse(500, {
      'error': '서버에 OPENWEATHER_API_KEY가 설정되지 않았습니다.',
    });
  }
  final city = request.url.queryParameters['city'];
  if (city == null || city.isEmpty) {
    return _jsonResponse(400, {'error': 'city 쿼리 파라미터가 필요합니다.'});
  }

  final uri = Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast'
    '?q=$city&appid=$apiKey&units=metric&lang=kr&cnt=40',
  );
  try {
    final response = await http.get(uri);
    return Response(
      response.statusCode,
      body: response.bodyBytes,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  } on Exception catch (e) {
    return _upstreamError(e);
  }
}

// ─── 뉴스 (Naver 검색 API) ──────────────────────────────────────────
//
// Naver Open API는 브라우저 CORS를 허용하지 않아 웹에서는 이 프록시 없이는
// 애초에 호출이 불가능합니다 (보안 목적뿐 아니라 기능적으로도 필수).

Future<Response> _newsHandler(Request request) async {
  final clientId = _env['NAVER_CLIENT_ID'] ?? '';
  final clientSecret = _env['NAVER_CLIENT_SECRET'] ?? '';
  if (clientId.isEmpty || clientSecret.isEmpty) {
    return _jsonResponse(500, {
      'error': '서버에 NAVER_CLIENT_ID/NAVER_CLIENT_SECRET이 설정되지 않았습니다.',
    });
  }
  final location = request.url.queryParameters['location'];
  if (location == null || location.isEmpty) {
    return _jsonResponse(400, {'error': 'location 쿼리 파라미터가 필요합니다.'});
  }

  final query = Uri.encodeComponent('$location 여행');
  final uri = Uri.parse(
    'https://openapi.naver.com/v1/search/news.json'
    '?query=$query&display=5&sort=date',
  );
  try {
    final response = await http.get(
      uri,
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );
    return Response(
      response.statusCode,
      body: response.bodyBytes,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  } on Exception catch (e) {
    return _upstreamError(e);
  }
}
