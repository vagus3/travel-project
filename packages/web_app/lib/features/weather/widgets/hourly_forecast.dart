import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/weather/models/weather_model.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key, required this.hourlyForecast});
  final List<HourlyForecastModel> hourlyForecast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '시간대별 상세',
              style: AppTypography.title.copyWith(color: colors.textPrimary),
            ),
            Text(
              '11월 24일 (금)',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 구름량 카드
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.cloud, color: colors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '구름량',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '시간별 구름 변화',
                        style: AppTypography.small.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 구름량 차트 (CustomPaint로 곡선 표현 가능하나 여기선 간략화)
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: hourlyForecast.take(5).map((h) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.cloud,
                          size: 24,
                          color: colors.textSecondary.withValues(
                            alpha: h.cloudCover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${h.hour}',
                          style: AppTypography.small.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 강수 확률 카드
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.water_drop, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '강수 확률',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '비가 올 가능성',
                        style: AppTypography.small.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 강수 확률 바 차트
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: hourlyForecast.map((h) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (h.precipitation > 0.1)
                            Text(
                              '${(h.precipitation * 100).toInt()}%',
                              style: AppTypography.small.copyWith(
                                fontSize: 10,
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Container(
                            width: 12,
                            height: 80 * h.precipitation, // 높이 계산
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${h.hour}',
                            style: AppTypography.small.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
