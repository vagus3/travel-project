import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template/features/weather/models/weather_model.dart';
import 'package:template/features/weather/repositories/weather_repository.dart';

part 'weather_controller.g.dart';

/// 날씨 화면 상태
class WeatherState {
  /// [WeatherState] 생성자
  WeatherState({
    this.currentWeather,
    this.dailyForecast = const [],
    this.hourlyForecast = const [],
    this.isLoading = true,
  });

  /// 현재 날씨 정보
  final CurrentWeatherModel? currentWeather;

  /// 7일 일간 예보
  final List<DailyForecastModel> dailyForecast;

  /// 시간대별 예보 (차트용)
  final List<HourlyForecastModel> hourlyForecast;

  /// 로딩 여부
  final bool isLoading;

  WeatherState copyWith({
    CurrentWeatherModel? currentWeather,
    List<DailyForecastModel>? dailyForecast,
    List<HourlyForecastModel>? hourlyForecast,
    bool? isLoading,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      dailyForecast: dailyForecast ?? this.dailyForecast,
      hourlyForecast: hourlyForecast ?? this.hourlyForecast,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출
@riverpod
class WeatherController extends _$WeatherController {
  final _repository = WeatherRepository();

  @override
  Future<WeatherState> build(DateTime date, String location) async {
    final current = await _repository.fetchCurrentWeather(location, date);
    final forecast = await _repository.fetchForecast(location, date);

    return WeatherState(
      currentWeather: current,
      dailyForecast: forecast.daily,
      hourlyForecast: forecast.hourly,
      isLoading: false,
    );
  }
}
