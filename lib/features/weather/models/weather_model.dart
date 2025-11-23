// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// 1. 현재 날씨 모델
class CurrentWeatherModel {
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
}

/// 2. 일간 예보 모델 (14일간 예보)
class DailyForecastModel {
  final String dayOfWeek; // "월", "화"
  final String dayOfMonth; // "27", "28"
  final IconData icon;
  final int maxTemp;
  final int minTemp;
  final bool isSelected; // 오늘 날짜(24일) 하이라이트 여부

  const DailyForecastModel({
    required this.dayOfWeek,
    required this.dayOfMonth,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    this.isSelected = false,
  });
}

/// 3. 시간대별 예보 모델 (차트용)
class HourlyForecastModel {
  final int hour; // 09, 12, 15...
  final double cloudCover; // 구름량 (0.0 ~ 1.0)
  final double precipitation; // 강수 확률 (0.0 ~ 1.0)

  const HourlyForecastModel({
    required this.hour,
    required this.cloudCover,
    required this.precipitation,
  });
}
