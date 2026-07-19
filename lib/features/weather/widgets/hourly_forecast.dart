import 'package:flutter/material.dart';
import 'package:template/features/weather/models/weather_model.dart';

const _kPrimaryColor = Color(0xFF4A90E2);
const _kCardLightColor = Color(0xFFF7F8FA);
const _kTextPrimaryColor = Color(0xFF333333);
const _kTextSecondaryColor = Color(0xFF999999);
const _kAccentGray = Color(0xFF778899);

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key, required this.hourlyForecast});
  final List<HourlyForecastModel> hourlyForecast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '시간대별 상세',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _kTextPrimaryColor,
              ),
            ),
            Text(
              '11월 24일 (금)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _kTextSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 구름량 카드
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _kCardLightColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud, color: _kAccentGray),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '구름량',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _kTextPrimaryColor,
                        ),
                      ),
                      Text(
                        '시간별 구름 변화',
                        style: TextStyle(
                          fontSize: 12,
                          color: _kTextSecondaryColor,
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
                          color: _kAccentGray.withOpacity(h.cloudCover),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${h.hour}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _kTextSecondaryColor,
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
            color: _kCardLightColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.water_drop, color: _kPrimaryColor),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '강수 확률',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _kTextPrimaryColor,
                        ),
                      ),
                      Text(
                        '비가 올 가능성',
                        style: TextStyle(
                          fontSize: 12,
                          color: _kTextSecondaryColor,
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
                              style: const TextStyle(
                                fontSize: 10,
                                color: _kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Container(
                            width: 12,
                            height: 80 * h.precipitation, // 높이 계산
                            decoration: BoxDecoration(
                              color: _kPrimaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${h.hour}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: _kTextSecondaryColor,
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
