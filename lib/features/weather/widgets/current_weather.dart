import 'package:flutter/material.dart';
import 'package:template/features/weather/models/weather_model.dart';

/// (View) '서울', '12°' 등 상단의 현재 날씨 정보 위젯
class CurrentWeatherWidget extends StatelessWidget {
  final CurrentWeatherModel currentWeather;

  const CurrentWeatherWidget({
    super.key,
    required this.currentWeather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. '서울'
        Text(
          currentWeather.location,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        // 2. '11월 24일 (금)'
        Text(
          currentWeather.date,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        // 3. 날씨 아이콘, 온도, 설명
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              currentWeather.icon,
              size: 80,
              color: Colors.yellow.shade700, // 맑음 아이콘 색
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentWeather.temperature}°',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentWeather.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
        // 4. '최고 / 최저'
        Text(
          '최고: ${currentWeather.maxTemp}° / 최저: ${currentWeather.minTemp}°',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 24),

        // 5. 체감온도, 습도, 풍속 카드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            color: Colors.grey[100], // 카드 배경색
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem('체감온도', '${currentWeather.feelsLike}°'),
                  _buildDetailItem('습도', '${currentWeather.humidity}%'),
                  _buildDetailItem('풍속', currentWeather.windSpeed),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 6. 상세 항목 (체감온도 등) 헬퍼
  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
