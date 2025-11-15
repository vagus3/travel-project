import 'package:flutter/material.dart';

/// 홈 화면 상단의 5개 아이콘 네비게이션 바
class TopIcon extends StatelessWidget {
  const TopIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 가로 스크롤을 사용하지 않고 5개 항목을 균등하게 배치하기 위해 Row와 Expanded를 사용합니다.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        // 2. 5개 아이콘을 가로축에서 동일한 간격으로 정렬
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 3. 각 아이콘 버튼을 _buildIconItem 헬퍼 함수로 생성
          _buildIconItem(context, Icons.flight_takeoff_outlined, '항공권'),
          _buildIconItem(context, Icons.hotel_outlined, '숙소'),
          _buildIconItem(context, Icons.local_activity_outlined, '투어·티켓'),
          _buildIconItem(context, Icons.directions_car_filled_outlined, '렌터카'),
          _buildIconItem(context, Icons.health_and_safety_outlined, '보험'),
        ],
      ),
    );
  }

  /// 4. 아이콘과 텍스트 라벨을 조합하는 헬퍼(Helper) 위젯
  Widget _buildIconItem(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        // 5. (구현 필요) 각 아이콘 탭했을 때 동작
        print('$label 탭됨');
      },
      borderRadius: BorderRadius.circular(8), // 탭 효과를 위한 둥근 모서리
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 6. 위젯이 차지하는 세로 공간 최소화
          children: [
            // 7. 아이콘
            Icon(
              icon,
              size: 28,
              color: Colors.blue.shade700, // 아이콘 색상
            ),
            const SizedBox(height: 8), // 아이콘과 텍스트 사이 간격
            // 8. 텍스트 라벨
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
