import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template/features/weather/models/weather_model.dart';

/// (View) '시간대별 상세 예보' 차트 위젯
class HourlyForecastWidget extends StatelessWidget {
  /// (View) '시간대별 상세 예보' 차트 위젯
  const HourlyForecastWidget({
    super.key,
    required this.hourlyForecast,
  });

  /// 컨트롤러로부터 받은 시간대별 예보 리스트
  final List<HourlyForecastModel> hourlyForecast;

  @override
  Widget build(BuildContext context) {
    if (hourlyForecast.isEmpty) {
      return const SizedBox.shrink(); // 데이터 없으면 표시 안함
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '시간대별 상세 예보',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            // 'ko_KR' 로케일을 사용하기 위해 main.dart에서 intl 초기화가 필요할 수 있습니다.
            DateFormat('M월 d일 (E)', 'ko_KR').format(DateTime.now()),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // --- 1. 구름량 차트 ---
          _buildChartCard(
            context: context,
            title: '구름량',
            icon: Icons.cloud_outlined,
            chartData: _buildCloudCoverChartData(),
            lineColor: Colors.grey,
            fillColor: Colors.grey.withAlpha(77), // withOpacity(0.3)
          ),
          const SizedBox(height: 16),
          // --- 2. 강수 확률 차트 ---
          _buildChartCard(
            context: context,
            title: '강수 확률',
            icon: Icons.umbrella_outlined,
            chartData: _buildPrecipitationChartData(),
            lineColor: Colors.blue,
            fillColor: Colors.blue.withAlpha(77), // withOpacity(0.3)
          ),
        ],
      ),
    );
  }

  /// 3. 차트를 감싸는 Card 위젯 헬퍼
  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required LineChartData chartData,
    required Color lineColor,
    required Color fillColor,
  }) {
    return Card(
      color: Colors.grey[50],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: lineColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 4. 차트가 그려질 영역 (높이 고정)
            SizedBox(
              height: 120,
              child: LineChart(chartData),
            ),
          ],
        ),
      ),
    );
  }

  /// 5. '구름량'을 위한 LineChartData 생성
  LineChartData _buildCloudCoverChartData() {
    // (Model) 컨트롤러에서 받은 데이터를 차트 데이터(FlSpot)로 변환
    final spots = hourlyForecast.map((forecast) {
      return FlSpot(
        forecast.hour.toDouble(),
        forecast.cloudCover * 100,
      ); // 0.8 -> 80%
    }).toList();

    return _buildBaseChartData(
      spots,
      Colors.grey,
      Colors.grey.withAlpha(77),
    ); // withOpacity(0.3)
  }

  /// 6. '강수 확률'을 위한 LineChartData 생성
  LineChartData _buildPrecipitationChartData() {
    // (Model) 컨트롤러에서 받은 데이터를 차트 데이터(FlSpot)로 변환
    final spots = hourlyForecast.map((forecast) {
      return FlSpot(
        forecast.hour.toDouble(),
        forecast.precipitation * 100,
      ); // 0.2 -> 20%
    }).toList();

    return _buildBaseChartData(
      spots,
      Colors.blue,
      Colors.blue.withAlpha(77),
    ); // withOpacity(0.3)
  }

  /// 7. 차트의 기본 디자인 (뼈대) - 최신 API로 수정
  LineChartData _buildBaseChartData(
    List<FlSpot> spots,
    Color lineColor,
    Color fillColor,
  ) {
    return LineChartData(
      // 2. (수정) 툴팁 설정
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // 3. (오류 수정) 'tooltipBgColor' -> 'getTooltipColor'로 변경
          getTooltipColor: (LineBarSpot touchedSpot) {
            return Colors.blueGrey; // 툴팁 배경색 반환
          },
          tooltipRoundedRadius: 8.0,
        ),
      ),
      // 4. 그리드(격자) 설정
      gridData: const FlGridData(show: false),
      // 5. 테두리 설정
      borderData: FlBorderData(show: false),

      // 6. (핵심 수정) 축(Title) 설정을 'titlesData'로 감싸기
      titlesData: FlTitlesData(
        // 7. (수정) rightTitles, topTitles를 FlTitlesData 내부로 이동
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // 8. (수정) leftTitles
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40, // Y축 라벨 공간
            getTitlesWidget: _yAxisFormatter, // Y축 포맷터 (0, 50, 100)
          ),
        ),
        // 9. (수정) bottomTitles
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30, // X축 라벨 공간
            interval: 3, // 3시간 간격 (09, 12, 15...)
            getTitlesWidget: _xAxisFormatter, // X축 포맷터 (HH:00)
          ),
        ),
      ),

      // 10. Y축 최소/최대값 (0% ~ 100%)
      minY: 0,
      maxY: 100,
      // 11. 실제 라인(Line) 데이터
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true, // 12. 곡선으로
          color: lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false), // 데이터 포인트 점 숨기기
          // 13. 라인 아래 영역 채우기 (Area Chart)
          belowBarData: BarAreaData(
            show: true,
            color: fillColor,
          ),
        ),
      ],
    );
  }

  /// 14. X축 라벨 포맷터 (예: 9.0 -> "09:00")
  Widget _xAxisFormatter(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(
        '${value.toInt().toString().padLeft(2, '0')}:00',
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }

  /// 15. Y축 라벨 포맷터 (예: 0, 50, 100)
  Widget _yAxisFormatter(double value, TitleMeta meta) {
    // 0, 50, 100일 때만 라벨 표시
    if (value == 0 || value == 50 || value == 100) {
      return Text(
        '${value.toInt()}',
        style: const TextStyle(color: Colors.grey, fontSize: 10),
        textAlign: TextAlign.right,
      );
    }
    return const SizedBox.shrink(); // 나머지는 숨김
  }
}
