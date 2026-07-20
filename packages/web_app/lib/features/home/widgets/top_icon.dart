import 'package:flutter/material.dart';

/// 홈 화면 상단의 5개 아이콘 메뉴 위젯
class TopIcon extends StatelessWidget {
  /// 홈 화면 상단의 5개 아이콘 메뉴 위젯
  const TopIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon('항공권', Icons.flight_takeoff_outlined),
          _buildIcon('숙소', Icons.hotel_outlined),
          _buildIcon('투어', Icons.tour_outlined),
          _buildIcon('렌터카', Icons.directions_car_outlined),
          _buildIcon('보험', Icons.health_and_safety_outlined),
        ],
      ),
    );
  }

  /// 아이콘과 텍스트를 조합하는 헬퍼 위젯
  Widget _buildIcon(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
