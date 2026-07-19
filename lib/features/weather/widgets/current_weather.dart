import 'package:flutter/material.dart';
import 'package:template/core/themes/app_colors.dart';
import 'package:template/features/weather/models/weather_model.dart';

/// 현재 날씨 위젯
class CurrentWeatherWidget extends StatelessWidget {
  /// [CurrentWeatherWidget] 생성자
  const CurrentWeatherWidget({super.key, required this.currentWeather});

  /// 현재 날씨 데이터
  final CurrentWeatherModel currentWeather;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // 위치 및 날짜
        Text(
          currentWeather.location,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          currentWeather.date,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 32),

        // 아이콘 및 온도
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(currentWeather.icon, size: 80, color: const Color(0xFFFFD700)),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentWeather.temperature}°',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
                Text(
                  currentWeather.description,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 최고/최저 온도 Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '최고: ${currentWeather.maxTemp}°',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 1,
                height: 16,
                color: colors.border,
              ),
              Text(
                '최저: ${currentWeather.minTemp}°',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 상세 정보 그리드 (체감온도, 습도, 풍속)
        Row(
          children: [
            _buildDetailCard(context, '체감온도', '${currentWeather.feelsLike}°'),
            const SizedBox(width: 16),
            _buildDetailCard(context, '습도', '${currentWeather.humidity}%'),
            const SizedBox(width: 16),
            _buildDetailCard(context, '풍속', currentWeather.windSpeed),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, String value) {
    final colors = context.colors;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
