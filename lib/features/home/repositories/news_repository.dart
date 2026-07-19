import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:template/features/home/models/news_model.dart';

/// Naver 뉴스 검색 API 연동 레포지토리
class NewsRepository {
  static const _baseUrl = 'https://openapi.naver.com/v1/search/news.json';

  String get _clientId => dotenv.env['NAVER_CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['NAVER_CLIENT_SECRET'] ?? '';

  /// 지역명 기반 여행 뉴스 조회
  Future<List<NewsArticle>> fetchNews(String location) async {
    final uri = Uri.parse(
      '$_baseUrl?query=${Uri.encodeComponent('$location 여행')}&display=5&sort=date',
    );
    final response = await http.get(
      uri,
      headers: {
        'X-Naver-Client-Id': _clientId,
        'X-Naver-Client-Secret': _clientSecret,
      },
    );

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
