import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/features/weather/controllers/weather_controller.dart';
import 'package:template/features/weather/widgets/current_weather.dart';
import 'package:template/features/weather/widgets/daily_forecast.dart';
import 'package:template/features/weather/widgets/hourly_forecast.dart';

/// '날씨' 탭 메인 화면 (View)
class WeatherScreen extends ConsumerWidget {
  ///날씨 화면
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 컨트롤러를 구독(watch)하여 날씨 상태(state)를 통째로 가져옴
    final weatherState = ref.watch(weatherControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 2. main.dart의 탭 화면이므로 뒤로가기 버튼(leading)은 제거
        automaticallyImplyLeading: false,
        title: const Text(
          '날씨',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () {
              // (구현 필요) 날짜/지역 선택
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // 3. 로딩 중이면 인디케이터 표시
      body: weatherState.isLoading
          ? const Center(child: CircularProgressIndicator())
          // 4. 로딩이 끝났고 데이터가 있으면, 분리된 위젯들을 조립
          : weatherState.currentWeather != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // --- 1. 상단 현재 날씨 ---
                  CurrentWeatherWidget(
                    currentWeather: weatherState.currentWeather!,
                  ),

                  // --- 2. 14일간(7일) 예보 ---
                  DailyForecastWidget(
                    dailyForecast: weatherState.dailyForecast,
                  ),

                  // --- 3. 시간대별 상세 예보 (차트) ---
                  HourlyForecastWidget(
                    hourlyForecast: weatherState.hourlyForecast,
                  ),
                ],
              ),
            )
          // 5. 로딩이 끝났는데 데이터가 없는 경우 (오류 등)
          : const Center(
              child: Text('날씨 정보를 불러올 수 없습니다.'),
            ),
    );
  }
}
