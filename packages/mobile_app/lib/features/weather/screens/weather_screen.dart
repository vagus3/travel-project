import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/features/home/controllers/travel_configuration_controller.dart';
import 'package:core/features/weather/controllers/weather_controller.dart';
import 'package:mobile_app/features/weather/widgets/current_weather.dart';
import 'package:mobile_app/features/weather/widgets/daily_forecast.dart';
import 'package:mobile_app/features/weather/widgets/hourly_forecast.dart';

/// 날씨 상세 화면
class WeatherScreen extends ConsumerStatefulWidget {
  ///날씨 화면
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  var _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: colors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final config = ref.watch(travelConfigurationProvider);
    final weatherState = ref.watch(
      weatherControllerProvider(_selectedDate, config.location),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          '날씨',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: colors.textPrimary,
            ),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: weatherState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : weatherState.when(
              data: (data) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CurrentWeatherWidget(
                        currentWeather: data.currentWeather!,
                      ),
                      const SizedBox(height: 40),
                      DailyForecastWidget(dailyForecast: data.dailyForecast),
                      const SizedBox(height: 40),
                      HourlyForecastWidget(hourlyForecast: data.hourlyForecast),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
    );
  }
}
