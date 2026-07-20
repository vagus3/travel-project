import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// OpenWeatherMap 아이콘 코드 → Flutter IconData 변환
IconData iconFromOwmCode(String code) {
  switch (code.substring(0, 2)) {
    case '01':
      return Icons.wb_sunny_rounded;
    case '02':
      return Icons.wb_cloudy_outlined;
    case '03':
    case '04':
      return Icons.cloud_outlined;
    case '09':
      return Icons.grain;
    case '10':
      return Icons.beach_access;
    case '11':
      return Icons.flash_on;
    case '13':
      return Icons.ac_unit;
    case '50':
      return Icons.blur_on;
    default:
      return Icons.wb_sunny_rounded;
  }
}

/// 1. 현재 날씨 모델
class CurrentWeatherModel {
  /// 현재 날씨 모델 생성자
  const CurrentWeatherModel({
    required this.location,
    required this.date,
    required this.icon,
    required this.temperature,
    required this.description,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  /// OpenWeatherMap `/weather` 응답으로부터 파싱
  factory CurrentWeatherModel.fromJson(
    Map<String, dynamic> json,
    DateTime date,
  ) {
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;

    return CurrentWeatherModel(
      location: json['name'] as String,
      date: DateFormat('MM월 dd일 (E)', 'ko_KR').format(date),
      icon: iconFromOwmCode(weather['icon'] as String),
      temperature: (main['temp'] as num).round(),
      description: weather['description'] as String,
      maxTemp: (main['temp_max'] as num).round(),
      minTemp: (main['temp_min'] as num).round(),
      feelsLike: (main['feels_like'] as num).round(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: '${(wind['speed'] as num).toStringAsFixed(1)}m/s',
    );
  }

  final String location;
  final String date;
  final IconData icon;
  final int temperature;
  final String description;
  final int maxTemp;
  final int minTemp;
  final int feelsLike;
  final int humidity;
  final String windSpeed;
}

/// 2. 일간 예보 모델 (7일 예보)
class DailyForecastModel {
  /// 일간 예보 모델 생성자
  const DailyForecastModel({
    required this.dayOfWeek,
    required this.dayOfMonth,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    this.isSelected = false,
  });

  final String dayOfWeek;
  final String dayOfMonth;
  final IconData icon;
  final int maxTemp;
  final int minTemp;
  final bool isSelected;
}

/// 3. 시간대별 예보 모델 (차트용)
class HourlyForecastModel {
  /// 시간대별 예보 모델 생성자
  const HourlyForecastModel({
    required this.hour,
    required this.cloudCover,
    required this.precipitation,
  });

  final int hour;
  final double cloudCover;
  final double precipitation;
}
