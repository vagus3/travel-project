import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';

class _CommunityPost {
  const _CommunityPost({
    required this.author,
    required this.profileImageUrl,
    required this.imageUrl,
    required this.createdAt,
    required this.content,
    required this.initialLikeCount,
  });

  final String author;
  final String profileImageUrl;
  final String imageUrl;
  final String createdAt;
  final String content;
  final int initialLikeCount;
}

/// 커뮤니티 이야기 위젯 — 게시물 탭 시 상세 모달을 띄웁니다.
class CommunityStoryWidget extends StatefulWidget {
  /// [CommunityStoryWidget] 생성자
  const CommunityStoryWidget({super.key});

  @override
  State<CommunityStoryWidget> createState() => _CommunityStoryWidgetState();
}

class _CommunityStoryWidgetState extends State<CommunityStoryWidget> {
  static const _post = _CommunityPost(
    author: 'traveler_kyoto',
    profileImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBC73IAzvSE_yn1i152QgW76wQxFgozFcdanX3fAtqS1bl0-qn0f7-TTR5mj7TQUiPEMKEFdTCP6D8sjMAjTVTVvh6nOG8KEiAs-3eS1cconjPKLanBcTvNcQzsT0kF2jL5LQ4reuUg0tNQPSBYwTddpAsPQkLX_ghdx9E9PpCHZshFVyHYEVJaIDaH0tuiK-ySdG3Gt0kd6d6tDOabzAzWWlpaIiGQdoc-dr6i2gWywOSRf8DqBSr0fbI2lSBdf2i35Dyh1QomR10g',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBFoA2UwWEes8xJabLIpixkZ-R_muV8L7yHsYJZY0iBp9a94TEB759nk5D9bvVj5ZrfnGUQwZHVaFvpCe3EkK_OIcv7Q7c2hfD1IrN6trcuXJ0HjbsR9XrW0NHF8KeGse5ajwyL8eGKUR7eG7lIrIPQZ_gaVNeRSg7FH6VyLHVPswUlNfefJTfSPVLVefKaGoaoY7fswRmp12IQKTHqAJxeDfpnCj2qBFLwt5CQAR_LwV6dD9dxJGiVGkAokOj8Ba4PxS7caPW5jj5K',
    createdAt: '2025-03-18',
    initialLikeCount: 12,
    content:
        '기요미즈데라의 해질녘은 정말 환상적이었어요! 🌇\n\n골목을 따라 천천히 올라가면 보이는 교토의 풍경과 '
        '노을이 어우러져 잊지 못할 순간을 선사해 줍니다. 방문 예정이시라면 일몰 시간을 꼭 체크해 보세요.',
  );

  int _likeCount = _post.initialLikeCount;
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likeCount -= 1;
      } else {
        _isLiked = true;
        _likeCount += 1;
      }
    });
  }

  void _openDetail(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _CommunityPostDialog(post: _post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '커뮤니티 이야기',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '전체보기',
                style: AppTypography.small.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => _openDetail(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(_post.profileImageUrl),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _post.author,
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.more_horiz, size: 20, color: colors.textSecondary),
                  ],
                ),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(_post.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: _toggleLike,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(_isLiked),
                                color: _isLiked ? colors.error : colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_likeCount',
                              style: AppTypography.label.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline, color: colors.textPrimary),
                    const SizedBox(width: 12),
                    Icon(Icons.send, color: colors.textPrimary),
                  ],
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${_post.author} ',
                        style: AppTypography.small.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: _post.content.split('\n').first,
                        style: AppTypography.small.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CommunityPostDialog extends StatelessWidget {
  const _CommunityPostDialog({required this.post});

  final _CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(post.profileImageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author,
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            post.createdAt,
                            style: AppTypography.small.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: colors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                child: Image.network(
                  post.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  post.content,
                  style: AppTypography.caption.copyWith(
                    height: 1.6,
                    color: colors.textSecondary,
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
