import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:mobile_app/features/home/widgets/home_weather.dart';
import 'package:mobile_app/features/home/widgets/local_recommendations.dart';
import 'package:mobile_app/features/home/widgets/quick_menu.dart';
import 'package:mobile_app/features/home/widgets/recent_news.dart';
import 'package:mobile_app/features/home/widgets/region_selection.dart';

/// HTML 디자인 기반의 홈 화면
class HomeScreen extends StatelessWidget {
  /// HomeScreen 생성자
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          '로컬 여행 정보',
          style: TextStyle(
            fontSize: context.titleFontSize,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: colors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(top: 8, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegionSelectionWidget(),
            SizedBox(height: 24),
            QuickMenuWidget(),
            SizedBox(height: 24),
            HomeWeatherWidget(),
            SizedBox(height: 24),
            LocalRecommendations(),
            SizedBox(height: 24),
            RecentNewsWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: const Icon(Icons.event_note, color: Colors.white),
      ),
    );
  }
}
