import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:core/features/home/models/news_model.dart';

/// Naver 뉴스 검색 연동 Repository
///
/// Naver Open API는 브라우저 CORS를 허용하지 않아 웹에서는 서버 프록시 없이는
/// 애초에 호출이 불가능합니다. NAVER_CLIENT_ID/SECRET은 `api_proxy` 백엔드가
/// 서버에서만 보관하고, 이 Repository는 `API_PROXY_BASE_URL`로 요청을 위임합니다.
class NewsRepository {
  String get _baseUrl =>
      dotenv.env['API_PROXY_BASE_URL'] ?? 'http://localhost:8080';

  /// 지역명 기반 여행 뉴스 조회
  Future<List<NewsArticle>> fetchNews(String location) async {
    final uri = Uri.parse(
      '$_baseUrl/api/news?location=${Uri.encodeComponent(location)}',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('뉴스 API 오류: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List;
    return items
        .map((e) => NewsArticle.fromNaverJson(e as Map<String, dynamic>))
        .toList();
  }
}
