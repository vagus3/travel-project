import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';

/// 활동 탭 (작성한 리뷰 / 저장한 장소)
class ActivityTabs extends StatelessWidget {
  /// [ActivityTabs] 생성자
  const ActivityTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  /// 현재 선택된 탭 인덱스
  final int selectedTabIndex;

  /// 탭 선택 콜백
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton(context, colors, 0, '작성한 리뷰'),
          _buildTabButton(context, colors, 1, '저장한 장소'),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    AppColors colors,
    int index,
    String title,
  ) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.textMuted,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
