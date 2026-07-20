import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';

/// 활동 목록 위젯
class ActivityList extends StatelessWidget {
  /// [ActivityList] 생성자
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ActivityItem(
          title: '도쿄 시부야 스카이 전망대',
          desc: '최고의 야경이었습니다! 정말 추천해요.',
          date: '2일 전',
          imgUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCYj2E1PjQxmgDVwIMxLVq3JqNopvMBuCq7hpjflbB8mwUE075vddojLh2gApI6nQbfKtgLqst-mGnCnr9R6zs6qWWkn8EwT73oNqWjM_Q-70rL3hLNIkbfzQFkH6YAqZuQDRV8Gf8KMUvGDqAzj1wOFxC3Uo-ObBNKajMwG_994Fv25LBJ55w1ILz8Kw7oA8q7k0GwZ62jBAK5qeZ5iZMbj1J_Bh8rDKVkA83bsm98753XG9hmZVWHRl7yEcihIN5l4EG7OoOQ6msQ',
        ),
        _ActivityItem(
          title: '교토 기온 거리 맛집',
          desc: '분위기도 좋고 음식도 맛있었어요.',
          date: '5일 전',
          imgUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAxdjYUU90wdoO1nvIR-0xa2SyGs3swlYzCA45-MzvlnIP30cbBDC3q8Vh8xBipJwJvkpGJJtqFW1okrKNOGiEPavK7MikuuhJAnIwRfvih4POHfWggbrzVW1zanSctOsm1DOPZyaUCIkEbINP9C9YVYt1bHwxiCSxoYRNVGiS9wuxsqzvRQUZdFp7jGGOMtfPf2UJOVJnje8JpArCjiJ3waFpRVfPSwsgwsvt2NQpNpqwa741PDzkk2HuZM0LsFsoc5y8bQpR89mhf',
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.title,
    required this.desc,
    required this.date,
    required this.imgUrl,
  });

  final String title;
  final String desc;
  final String date;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTypography.small.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: AppTypography.small.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
