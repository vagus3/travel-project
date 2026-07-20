import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:core/features/weather/models/weather_model.dart';

/// OpenWeatherMap 연동 Repository
///
/// OPENWEATHER_API_KEY는 클라이언트가 아니라 `api_proxy` 백엔드가 서버에서만
/// 보관합니다. 이 Repository는 `API_PROXY_BASE_URL`로 요청을 위임합니다.
class WeatherRepository {
  String get _baseUrl =>
      '${dotenv.env['API_PROXY_BASE_URL'] ?? 'http://localhost:8080'}/api/weather';

  /// 현재 날씨 조회
  Future<CurrentWeatherModel> fetchCurrentWeather(
    String city,
    DateTime date,
  ) async {
    final uri = Uri.parse('$_baseUrl/current?city=$city');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('날씨 API 오류: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return CurrentWeatherModel.fromJson(json, date);
  }

  /// 5일 예보 조회 → 일간/시간별 예보로 변환
  Future<({List<DailyForecastModel> daily, List<HourlyForecastModel> hourly})>
  fetchForecast(String city, DateTime startDate) async {
    final uri = Uri.parse('$_baseUrl/forecast?city=$city');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('예보 API 오류: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final list = json['list'] as List;

    // 날짜별 그룹핑으로 일간 예보 생성
    final byDay = <String, List<Map<String, dynamic>>>{};
    for (final item in list) {
      final entry = item as Map<String, dynamic>;
      final dt = DateTime.fromMillisecondsSinceEpoch(
        (entry['dt'] as int) * 1000,
      );
      final key = DateFormat('yyyy-MM-dd').format(dt);
      byDay.putIfAbsent(key, () => []).add(entry);
    }

    final daily = byDay.entries.take(7).toList().asMap().entries.map((e) {
      final index = e.key;
      final entry = e.value;
      final date = DateTime.parse(entry.key);
      final items = entry.value;
      final temps = items.map((i) => (i['main'] as Map)['temp'] as num);
      final firstWeather =
          (items.first['weather'] as List).first as Map<String, dynamic>;

      return DailyForecastModel(
        dayOfWeek: DateFormat('E', 'ko_KR').format(date),
        dayOfMonth: DateFormat('d').format(date),
        icon: iconFromOwmCode(firstWeather['icon'] as String),
        maxTemp: temps.reduce((a, b) => a > b ? a : b).round(),
        minTemp: temps.reduce((a, b) => a < b ? a : b).round(),
        isSelected: index == 0,
      );
    }).toList();

    // 처음 8개 슬롯으로 시간별 예보 생성
    final hourly = list.take(8).map((item) {
      final entry = item as Map<String, dynamic>;
      final dt = DateTime.fromMillisecondsSinceEpoch(
        (entry['dt'] as int) * 1000,
      );
      final clouds = (entry['clouds'] as Map)['all'] as num;
      final pop = (entry['pop'] as num?) ?? 0;

      return HourlyForecastModel(
        hour: dt.hour,
        cloudCover: clouds / 100.0,
        precipitation: pop.toDouble(),
      );
    }).toList();

    return (daily: daily, hourly: hourly);
  }
}
