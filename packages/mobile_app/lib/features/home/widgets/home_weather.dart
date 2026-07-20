import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/home/controllers/travel_configuration_controller.dart';
import 'package:core/features/weather/controllers/weather_controller.dart';
import 'package:mobile_app/features/weather/screens/weather_screen.dart';

/// 홈 화면 날씨 요약 위젯
class HomeWeatherWidget extends StatelessWidget {
  /// [HomeWeatherWidget] 생성자
  const HomeWeatherWidget({super.key});

  void _openWeatherDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const WeatherScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer(
      builder: (context, ref, child) {
        final config = ref.watch(travelConfigurationProvider);
        final date = config.dateRange?.start ?? DateTime.now();
        final weatherState = ref.watch(
          weatherControllerProvider(date, config.location),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.hPad,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '실시간 ${config.location} 날씨',
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => _openWeatherDetail(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '더보기',
                            style: AppTypography.small.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            weatherState.when(
              data: (state) {
                final weather = state.currentWeather;
                if (weather == null) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.hPad),
                  child: InkWell(
                    onTap: () => _openWeatherDetail(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary,
                            colors.primary.withValues(alpha: 0.75),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(weather.icon, color: Colors.white, size: 48),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weather.description,
                                    style: AppTypography.title.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    '습도: ${weather.humidity}%',
                                    style: AppTypography.small.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${weather.temperature}°',
                                style: AppTypography.heading.copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '최고 ${weather.maxTemp}° / 최저 ${weather.minTemp}°',
                                style: AppTypography.small.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => Container(
                margin: EdgeInsets.symmetric(horizontal: context.hPad),
                height: 100,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Container(
                margin: EdgeInsets.symmetric(horizontal: context.hPad),
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  '날씨 정보를 불러올 수 없습니다.',
                  style: TextStyle(color: colors.textMuted),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
