import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:mobile_app/features/home/screens/place_detail_screen.dart';

/// '현지 추천 장소' 가로 스크롤 위젯
class LocalRecommendations extends StatelessWidget {
  /// '현지 추천 장소' 가로 스크롤 위젯
  const LocalRecommendations({super.key});

  static const _recommendations = <Map<String, Object>>[
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCWSt2n8d0UpTjiuwSsuJE9WoroXrWdWl27Lb3WgRrtDtifF5BHUYX0aMtXX1LLNsWmlXTTSI8lLFSwTmYLQtDCQrX8z7L8dLAWEAjfRqdAiY934sIZAQ_UieUC-XoQ-XSSPRljRlRbGO7Nt_FZcBloj8v958lwqTMSncpVY-gxtRQp3fRNCfA8ZqWkKsYuBlFLgTQggIee9eNzttFz4BkmRCohFgkZIQbtZJZ0UtWjn4t5wDyGE-FL8AtNDgExI4uofYCLiZZ4WIQs',
      'title': '후시미 이나리 신사',
      'location': '교토 · 후시미구',
      'rating': 4.9,
      'reviewCount': 5820,
      'hours': '24시간 개방',
      'fee': '입장 무료',
      'description': '수천 개의 붉은 도리이 게이트가 이어지는 신비로운 산길로 유명한 신사입니다. '
          '이나리산 전체가 신사 영역으로, 정상까지 약 2~3시간이 소요되는 하이킹 코스를 따라 걸으며 '
          '일본 전통 신앙과 자연을 동시에 체험할 수 있습니다.',
      'tags': ['신사', '하이킹', '포토스팟', '역사', '무료입장'],
      'tips': [
        {'icon': '🌅', 'text': '이른 아침 방문 시 인파가 적어 여유롭게 감상 가능'},
        {'icon': '📸', 'text': '도리이 터널 안에서 역광 사진이 인상적'},
        {'icon': '👟', 'text': '정상까지 걷는 경우 운동화 필수'},
      ],
    },
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAdmNyqIK80mWXaNbl4M9r6P4nwBpTW8HWXg2Cl058P2qv94jZdIO6amXwX2bWinL081CIlPa5bbS4BDBUcoaVF4CeY8ELYh7CayS6aOSvwu031iGlikj3ZKrk9m9npbHZGe6qW7_DsEimpiMuJVPds5AA09A_r9R5873gP9mtCg6BvZcw4pOBktUjQsho8A8kQrst4eQxfNJPONc51pNBPhT-GK_2Z5CuMNXr-J4jkPV-Zg-Gut1f6vxwN-VJN5_jFdbEnFgMWbyFr',
      'title': '금각사 (킨카쿠지)',
      'location': '교토 · 키타구',
      'rating': 4.8,
      'reviewCount': 7430,
      'hours': '09:00 ~ 17:00',
      'fee': '성인 500엔',
      'description': '금박으로 뒤덮인 사리전이 연못에 비치는 모습이 압도적인 세계문화유산입니다.',
      'tags': ['세계문화유산', '사원', '정원', '역사', '포토스팟'],
      'tips': [
        {'icon': '⛅', 'text': '맑은 날 연못에 비치는 금각이 가장 아름다움'},
        {'icon': '🎋', 'text': '겨울 적설 시즌에 방문하면 특별한 풍경 연출'},
        {'icon': '🚌', 'text': '교토역에서 버스로 약 40분 소요'},
      ],
    },
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCoOaBHK_HQ1nuagP2kxm-TH3YBIH2cxwEiZ-T8Fqk_gdN-O970DadR22lQNUB3UMwdapYIespcxLr_pRXDL8OJteK9p43aTL5qaU2s0LZvohVkiq4cbvCxmjNuZ7e4mBEKWEjOZAyH-cMB7C7_MtfE1eX9xA-ENxQdg-C6FhkUFtaKldt4mLVTxGZ5S_XnMVf97_zXMvXunZVZ_OTZilDYeCROtcUE16GWS2WPoJtGjdp50WyfjujSON4e9pC-wOfXbqgT1-KPxx5G',
      'title': '아라시야마 대나무 숲',
      'location': '교토 · 우쿄구',
      'rating': 4.7,
      'reviewCount': 4120,
      'hours': '24시간 개방',
      'fee': '입장 무료',
      'description': '하늘을 향해 쭉 뻗은 대나무들이 만들어내는 녹색 터널로, 교토에서 가장 이국적인 풍경 중 하나입니다.',
      'tags': ['자연', '대나무', '산책', '포토스팟', '무료입장'],
      'tips': [
        {'icon': '🌿', 'text': '이른 아침이 조용하고 빛이 가장 아름다운 시간'},
        {'icon': '🚂', 'text': '사가노 관광열차와 함께 코스로 즐기면 최고'},
        {'icon': '☔', 'text': '비 온 후 촉촉한 대나무 숲도 색다른 매력'},
      ],
    },
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBFoA2UwWEes8xJabLIpixkZ-R_muV8L7yHsYJZY0iBp9a94TEB759nk5D9bvVj5ZrfnGUQwZHVaFvpCe3EkK_OIcv7Q7c2hfD1IrN6trcuXJ0HjbsR9XrW0NHF8KeGse5ajwyL8eGKUR7eG7lIrIPQZ_gaVNeRSg7FH6VyLHVPswUlNfefJTfSPVLVefKaGoaoY7fswRmp12IQKTHqAJxeDfpnCj2qBFLwt5CQAR_LwV6dD9dxJGiVGkAokOj8Ba4PxS7caPW5jj5K',
      'title': '기요미즈데라',
      'location': '교토 · 히가시야마구',
      'rating': 4.9,
      'reviewCount': 9100,
      'hours': '06:00 ~ 18:00',
      'fee': '성인 400엔',
      'description': '교토 동쪽 히가시야마 구릉에 자리한 유네스코 세계문화유산으로, 못을 전혀 사용하지 않고 지어진 목조 무대가 특징입니다.',
      'tags': ['세계문화유산', '사원', '전망', '역사', '벚꽃명소'],
      'tips': [
        {'icon': '🌸', 'text': '봄 벚꽃 시즌에 야간 라이트업 이벤트 진행'},
        {'icon': '🍁', 'text': '11월 단풍철이 최고 인기 시즌 (사전 예약 권장)'},
        {'icon': '💧', 'text': '경내 세 줄기 폭포수를 마시면 소원 성취한다는 전설'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardWidth = context.isTablet ? 320.0 : 260.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.hPad, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '지금 가장 핫한 장소',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '추천 리스트',
                style: AppTypography.small.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final item = _recommendations[index];
              final isLast = index == _recommendations.length - 1;
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    pageBuilder: (ctx, a1, a2) => PlaceDetailScreen(place: item),
                    transitionsBuilder: (_, animation, a2, child) {
                      final tween = Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                ),
                child: Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(right: isLast ? 0 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item['image']! as String,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 그라디언트 오버레이
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                            stops: [0.6, 1.0],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['location']! as String,
                                style: AppTypography.micro.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['title']! as String,
                              style: AppTypography.subtitle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
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
    );
  }
}
