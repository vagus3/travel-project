import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';

/// 여행지 상세 정보 화면
class PlaceDetailScreen extends StatelessWidget {
  /// 장소 데이터
  final Map<String, dynamic> place;

  /// PlaceDetailScreen 생성자
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final String title = place['title'] as String? ?? '';
    final String image = place['image'] as String? ?? '';
    final String location = place['location'] as String? ?? '교토';
    final String description = place['description'] as String? ??
        '이곳은 일본 교토를 대표하는 명소 중 하나로, 매년 수백만 명의 관광객이 방문하는 인기 여행지입니다. '
            '아름다운 전통 건축물과 자연경관이 조화를 이루며, 일본의 역사와 문화를 깊이 체험할 수 있습니다.';
    final double rating = (place['rating'] as num?)?.toDouble() ?? 4.8;
    final int reviewCount = (place['reviewCount'] as int?) ?? 2341;
    final String hours = place['hours'] as String? ?? '06:00 ~ 18:00';
    final String fee = place['fee'] as String? ?? '입장 무료';
    final List<String> tags = (place['tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['역사', '전통', '자연', '포토스팟'];
    final List<Map<String, String>> tips =
        (place['tips'] as List<dynamic>?)?.map((e) {
              final m = e as Map;
              return {
                'icon': m['icon']?.toString() ?? '💡',
                'text': m['text']?.toString() ?? '',
              };
            }).toList() ??
            [
              {'icon': '🌅', 'text': '이른 아침 방문 시 인파가 적어 여유롭게 감상 가능'},
              {'icon': '📸', 'text': '일출 직후 황금빛 빛이 들어오는 시간대가 최고 포토타임'},
              {'icon': '👟', 'text': '계단이 많으니 편한 신발 착용 권장'},
            ];

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // 상단 이미지 + 앱바
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: colors.surface,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: colors.border,
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: Colors.white),
                    ),
                  ),
                  // 그라디언트 오버레이 (사진 위 텍스트 가독성용 — 테마 무관)
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x55000000),
                          Colors.transparent,
                          Color(0xAA000000),
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // 하단 제목
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            location,
                            style: AppTypography.small.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: AppTypography.heading.copyWith(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                  color: Colors.black45,
                                  blurRadius: 8,
                                  offset: Offset(0, 2))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
                tooltip: '공유',
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                tooltip: '찜하기',
              ),
            ],
          ),

          // 본문 콘텐츠
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 평점 & 리뷰
                  _RatingRow(rating: rating, reviewCount: reviewCount),
                  const SizedBox(height: 20),

                  // 태그
                  _TagRow(tags: tags),
                  const SizedBox(height: 24),

                  // 설명
                  const _SectionTitle(title: '장소 소개'),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: AppTypography.body.copyWith(
                      fontSize: 15,
                      color: colors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 방문 정보
                  const _SectionTitle(title: '방문 정보'),
                  const SizedBox(height: 12),
                  _InfoCard(hours: hours, fee: fee),
                  const SizedBox(height: 24),

                  // 여행 팁
                  const _SectionTitle(title: '여행 팁'),
                  const SizedBox(height: 12),
                  ...tips.map(
                    (tip) => _TipItem(icon: tip['icon']!, text: tip['text']!),
                  ),
                  const SizedBox(height: 32),

                  // 일정 추가 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('일정에 추가되었습니다!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.white),
                      label: Text(
                        '내 일정에 추가',
                        style: AppTypography.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 서브 위젯들 ───────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.subtitle.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;
  const _RatingRow({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(Icons.star_rounded, color: colors.warning, size: 22),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '리뷰 ${reviewCount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}개',
          style: AppTypography.label.copyWith(color: colors.textMuted),
        ),
        const Spacer(),
        Icon(Icons.location_on_outlined, color: colors.textSecondary, size: 16),
        const SizedBox(width: 2),
        Text(
          '일본 · 교토',
          style: AppTypography.label.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _TagRow extends StatelessWidget {
  final List<String> tags;
  const _TagRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '# $tag',
                style: AppTypography.small.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String hours;
  final String fee;
  const _InfoCard({required this.hours, required this.fee});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: '운영 시간',
            value: hours,
          ),
          Divider(height: 20, color: colors.border),
          _InfoRow(
            icon: Icons.confirmation_number_outlined,
            label: '입장료',
            value: fee,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.micro.copyWith(color: colors.textMuted)),
            const SizedBox(height: 2),
            Text(value,
                style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ],
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  final String icon;
  final String text;
  const _TipItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
