// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/weather/models/weather_model.dart';

/// (View) '14일간 예보' 가로 스크롤 리스트 위젯
class DailyForecastWidget extends StatelessWidget {
  const DailyForecastWidget({
    super.key,
    required this.dailyForecast,
  });

  final List<DailyForecastModel> dailyForecast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '14일간 예보',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              // 요일 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .map(
                      (day) => SizedBox(
                        width: 30,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: AppTypography.small.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: colors.border),
              const SizedBox(height: 12),
              // 날짜 그리드 (Wrap으로 구현)
              Wrap(
                spacing: 4, // 가로 간격
                runSpacing: 12, // 세로 간격
                children: dailyForecast.map((item) {
                  // 화면 너비에 맞춰 대략적인 너비 계산 (padding 고려)
                  final width = (MediaQuery.of(context).size.width - 88) / 7;
                  return SizedBox(
                    width: width,
                    child: Column(
                      children: [
                        Text(
                          item.dayOfMonth,
                          style: AppTypography.small.copyWith(
                            fontWeight: FontWeight.bold,
                            color: item.isSelected
                                ? colors.primary
                                : colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          item.icon,
                          size: 20,
                          color: item.icon == Icons.wb_sunny_rounded
                              ? colors.warning
                              : colors.textSecondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${item.maxTemp}°/${item.minTemp}°',
                          style: AppTypography.small.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 온도 바 (간단한 시각화)
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.6, // 임의의 값 (실제 데이터 연동 필요)
                            child: Container(
                              decoration: BoxDecoration(
                                color: item.icon == Icons.wb_sunny_rounded
                                    ? colors.warning
                                    : colors.textSecondary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
