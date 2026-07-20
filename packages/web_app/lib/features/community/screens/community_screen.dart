import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:web_app/features/home/widgets/travel_post_card.dart';

/// 커뮤니티 탭 화면 — 여행 포스트 피드를 표시합니다.
class CommunityScreen extends StatelessWidget {
  /// [CommunityScreen] 생성자
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '커뮤니티',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24),
        child: TravelPostFeed(showHeader: false),
      ),
    );
  }
}
