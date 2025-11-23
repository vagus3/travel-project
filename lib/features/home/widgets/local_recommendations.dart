// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'dart:developer';

import 'package:flutter/material.dart';

/// 홈 화면의 '현지 추천 장소' 가로 스크롤 위젯
class LocalRecommendations extends StatelessWidget {
  /// 현지 장소 추천 배너 업데이트
  const LocalRecommendations({super.key});

  // (임시) 추천 장소 데이터
  // (실제 앱에서는 이 데이터를 Firebase 등에서 가져와야 합니다)
  static const _recommendations = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1545569341-9921e141119c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxhcmFzaGl5YW1hJTIwYmFtYm9vJTIwZ3JvdmV8ZW58MHx8fHwxNzMxNjgxMTE2fDA&ixlib=rb-4.0.3&q=80&w=1080', // 아라시야마 대나무 숲 (대체)
      'title': '후시미 이나리 신사',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1545904832-51b80d09d8d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxraW5rYWt1amklMjB0ZW1wbGV8ZW58MHx8fHwxNzMxNjgxMTM2fDA&ixlib=rb-4.0.3&q=80&w=1080', // 금각사 (대체)
      'title': '금각사 (킨카쿠지)',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1554797589-7246187063f4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0b2t5byUyMHNreXRyZWV8ZW58MHx8fHwxNzMxNjgxMTYyfDA&ixlib=rb-4.0.3&q=80&w=1080', // 도쿄 스카이트리 (대체)
      'title': '도쿄 스카이트리',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 1. 가로 스크롤 뷰는 부모 위젯이 명확한 높이값을 지정해줘야 합니다.
    return SizedBox(
      height: 150, // 가로 스크롤 영역의 전체 높이
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 2. 가로 스크롤 설정
        itemCount: _recommendations.length, // 3. 임시 데이터의 개수만큼 생성
        // 4. 리스트의 좌우에 패딩을 줍니다.
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = _recommendations[index];
          // 5. 각 항목을 렌더링
          return _buildRecommendationCard(
            context,
            item['imageUrl']!,
            item['title']!,
          );
        },
      ),
    );
  }

  /// 6. 추천 장소 카드 UI를 구성하는 헬퍼 위젯
  Widget _buildRecommendationCard(
    BuildContext context,
    String imageUrl,
    String title,
  ) {
    return Container(
      width: 220, // 7. 각 카드의 너비 지정
      margin: const EdgeInsets.only(right: 12), // 8. 카드 사이의 간격
      child: InkWell(
        onTap: () {
          // 9. (구현 필요) 카드 클릭 시 동작
          log('$title 탭됨');
        },
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          // 10. 이미지와 텍스트에 둥근 모서리 적용
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand, // 11. 이미지가 Stack을 꽉 채우도록 설정
            children: [
              // 12. 배경 이미지 (네트워크 이미지 사용)
              Image.network(
                imageUrl,
                fit: BoxFit.cover, // 이미지가 카드를 꽉 채우고 비율 유지
                // 13. 이미지 로딩 중/실패 시 처리
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  );
                },
              ),
              // 14. 이미지 위에 어두운 그라데이션 오버레이 (텍스트가 잘 보이도록)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 1.0], // 그라데이션 범위 조절
                  ),
                ),
              ),
              // 15. 이미지 하단에 텍스트 배치
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      // 텍스트 그림자 (가독성 향상)
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
