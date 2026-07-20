import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:core/features/home/controllers/news_controller.dart';
import 'package:core/features/home/models/news_model.dart';

/// 최근 뉴스 위젯 — newsControllerProvider 구독
class RecentNewsWidget extends ConsumerWidget {
  /// [RecentNewsWidget] 생성자
  const RecentNewsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final newsAsync = ref.watch(newsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.hPad, vertical: 12),
          child: Text(
            '최근 뉴스',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        ),
        newsAsync.when(
          data: (List<NewsArticle> articles) {
            if (articles.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.hPad),
                child: Text(
                  '뉴스를 불러올 수 없습니다.',
                  style: TextStyle(color: colors.textMuted),
                ),
              );
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: context.hPad),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: articles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final article = entry.value;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          article.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${article.source} · ${article.timeAgo}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      if (index != articles.length - 1)
                        Divider(height: 1, color: colors.border),
                    ],
                  );
                }).toList(),
              ),
            );
          },
          loading: () => Container(
            margin: EdgeInsets.symmetric(horizontal: context.hPad),
            height: 100,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (_, stack) => Container(
            margin: EdgeInsets.symmetric(horizontal: context.hPad),
            height: 60,
            alignment: Alignment.center,
            child: Text(
              'API 키를 .env 파일에 설정해주세요.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
