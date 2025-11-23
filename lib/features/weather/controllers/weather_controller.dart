// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:template/features/weather/models/weather_model.dart';

/// 이 컨트롤러가 관리할 상태(State)
class WeatherState {
  final CurrentWeatherModel? currentWeather;
  final List<DailyForecastModel> dailyForecast;
  final List<HourlyForecastModel> hourlyForecast;
  final bool isLoading;

  WeatherState({
    this.currentWeather,
    this.dailyForecast = const [],
    this.hourlyForecast = const [],
    this.isLoading = true,
  });

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

/// (Controller) 날씨 데이터를 관리하는 컨트롤러
class WeatherController extends StateNotifier<WeatherState> {
  WeatherController() : super(WeatherState()) {
    fetchWeather(); // 생성 시 데이터 로드
  }

  /// (임시) 날씨 데이터를 생성하는 함수
  Future<void> fetchWeather() async {
    state = state.copyWith(isLoading: true);
    // (실제 앱에서는 여기서 OpenWeatherMap, 기상청 API 등을 호출)
    await Future.delayed(const Duration(milliseconds: 500));

    // --- 1. 임시 현재 날씨 데이터 ---
    const current = CurrentWeatherModel(
      location: '서울',
      date: '11월 24일 (금)',
      icon: Icons.wb_sunny_rounded,
      temperature: 12,
      description: '대체로 맑음',
      maxTemp: 15,
      minTemp: 8,
      feelsLike: 11,
      humidity: 45,
      windSpeed: '2m/s',
    );

    // --- 2. 임시 14일간(여기선 7일) 예보 데이터 ---
    final daily = [
      const DailyForecastModel(
        dayOfWeek: '금',
        dayOfMonth: '24',
        icon: Icons.wb_sunny_rounded,
        maxTemp: 15,
        minTemp: 8,
        isSelected: true,
      ),
      const DailyForecastModel(
        dayOfWeek: '토',
        dayOfMonth: '25',
        icon: Icons.cloud_outlined,
        maxTemp: 14,
        minTemp: 7,
      ),
      const DailyForecastModel(
        dayOfWeek: '일',
        dayOfMonth: '26',
        icon: Icons.beach_access,
        maxTemp: 12,
        minTemp: 6,
      ),
      const DailyForecastModel(
        dayOfWeek: '월',
        dayOfMonth: '27',
        icon: Icons.cloudy_snowing,
        maxTemp: 11,
        minTemp: 4,
      ),
      const DailyForecastModel(
        dayOfWeek: '화',
        dayOfMonth: '28',
        icon: Icons.wb_sunny_outlined,
        maxTemp: 14,
        minTemp: 6,
      ),
      const DailyForecastModel(
        dayOfWeek: '수',
        dayOfMonth: '29',
        icon: Icons.cloud_outlined,
        maxTemp: 12,
        minTemp: 7,
      ),
      const DailyForecastModel(
        dayOfWeek: '목',
        dayOfMonth: '30',
        icon: Icons.ac_unit,
        maxTemp: 8,
        minTemp: 4,
      ),
      // ... (디자인의 14개 데이터를 모두 추가 가능)
    ];

    // --- 3. 임시 시간대별 예보 (차트용) ---
    final hourly = [
      const HourlyForecastModel(hour: 9, cloudCover: 0.3, precipitation: 0.1),
      const HourlyForecastModel(hour: 12, cloudCover: 0.5, precipitation: 0.1),
      const HourlyForecastModel(hour: 15, cloudCover: 0.8, precipitation: 0.2),
      const HourlyForecastModel(hour: 18, cloudCover: 0.6, precipitation: 0.4),
      const HourlyForecastModel(hour: 21, cloudCover: 0.4, precipitation: 0),
    ];

    // --- 4. 상태 업데이트 -> UI 새로고침 ---
    state = state.copyWith(
      currentWeather: current,
      dailyForecast: daily,
      hourlyForecast: hourly,
      isLoading: false,
    );
  }
}

/// (Provider) View가 Controller에 접근할 수 있도록 하는 전역 프로바이더
final weatherControllerProvider =
    StateNotifierProvider<WeatherController, WeatherState>(
      (ref) => WeatherController(),
    );
