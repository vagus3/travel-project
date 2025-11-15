import 'package:flutter/material.dart';
// 1. (참고) 이 위젯들은 아직 생성하지 않아서 에러로 표시될 수 있습니다.
import 'package:template/features/home/widgets/local_recommendations.dart';
import 'package:template/features/home/widgets/post_card.dart';
import 'package:template/features/home/widgets/top_icon.dart';

/// 사용자가 업로드한 이미지(image_8a7524.jpg) 기반의 홈 화면 UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. 상단 AppBar (앱바)
      appBar: AppBar(
        title: const Text(
          '한일이',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // 알림 버튼 클릭 시 동작
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white, // 전체 화면 배경색
      body: SingleChildScrollView(
        // 3. 전체 스크롤 가능한 뷰
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4. 상단 아이콘 메뉴 5개 (항공권, 숙소, 투어, 렌터카, 보험)
            // (참고) 이 위젯은 곧 생성해 드립니다.
            const TopIcon(),

            // 5. '현지 추천 장소' 섹션
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                '현지 추천 장소',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 6. '현지 추천 장소' 가로 스크롤 위젯
            // (참고) 이 위젯은 곧 생성해 드립니다.
            const LocalRecommendations(),

            // 7. 구분선
            Divider(
              height: 32,
              thickness: 8,
              color: Colors.grey[100],
            ),

            // 8. 세로 피드 목록 (ListView.builder 사용 권장)
            // (참고) 이 위젯은 곧 생성해 드립니다.
            TravelPostCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1548625149-fc4a874b73e5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxyZWQlMjBqYXBhbmVzZSUyMHNocmluZXxlbnwwfHx8fDE3MzE2Nzk3NDZ8MA&ixlib=rb-4.0.3&q=80&w=1080', // 교토 사시미 이미지 (대체)
              title: '교토 현지인만 아는 맛집 리스트 공유합니다.',
              author: '여행매니아',
              timeAgo: '2시간 전',
              profileImageUrl:
                  'https://placehold.co/100x100/E0E0E0/BDBDBD?text=P',
            ),
            TravelPostCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1549468057-5b7fa1a41d7c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxvcyVFQSVCQSVCN2ElMjBjYXN0bGUlMjBuaWdodHxlbnwwfHx8fDE3MzE2Nzk3NzZ8MA&ixlib=rb-4.0.3&q=80&w=1080', // 오사카성 (대체)
              title: '오사카에서 3박 4일 여행 코스 추천해줘요!',
              author: '오사카보이',
              timeAgo: '5시간 전',
              profileImageUrl:
                  'https://placehold.co/100x100/C5CAE9/9FA8DA?text=O',
            ),
            TravelPostCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1547738021-87c2b54c8b67?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0b2t5byUyMGRpc25leSUyMGZpcmV3b3Jrc3xlbnwwfHx8fDE3MzE2Nzk3OTh8MA&ixlib=rb-4.0.3&q=80&w=1080', // 디즈니랜드 (대체)
              title: '도쿄 디즈니랜드 꿀팁 대방출! (스압주의)',
              author: '디즈니덕후',
              timeAgo: '1일 전',
              profileImageUrl:
                  'https://placehold.co/100x100/F8BBD0/F48FB1?text=D',
            ),
          ],
        ),
      ),
    );
  }
}
