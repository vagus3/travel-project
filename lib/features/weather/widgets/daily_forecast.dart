// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:template/features/weather/models/weather_model.dart';

/// (View) '14일간 예보' 가로 스크롤 리스트 위젯
class DailyForecastWidget extends StatelessWidget {
  const DailyForecastWidget({
    super.key,
    required this.dailyForecast,
  });

  final List<DailyForecastModel> dailyForecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '14일간 예보',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // 1. 가로 스크롤을 위해 높이 고정
          SizedBox(
            height: 130, // 각 항목의 높이
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 2. 가로 스크롤
              itemCount: dailyForecast.length,
              itemBuilder: (context, index) {
                final day = dailyForecast[index];
                // 3. 오늘 날짜(isSelected)인지 확인
                final isSelected = day.isSelected;

                // 4. 각 날짜 카드
                return Container(
                  width: 70, // 각 항목 너비
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    // 5. 선택된 항목(오늘)은 파란색 배경, 나머지는 연한 회색
                    color: isSelected ? Colors.blue.shade700 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          day.dayOfWeek, // "금", "토"
                          style: TextStyle(
                            fontSize: 14,
                            // 6. 선택된 항목은 흰색 글씨
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          day.dayOfMonth, // "24", "25"
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        Icon(
                          day.icon,
                          size: 28,
                          color: isSelected
                              ? Colors.white
                              : Colors.blue.shade700,
                        ),
                        Text(
                          '${day.maxTemp}°/${day.minTemp}°',
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
