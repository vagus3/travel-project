import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/features/home/controllers/travel_post_controller.dart';
import 'package:template/features/home/models/post_model.dart';

/// 홈 화면 / 커뮤니티 탭에 표시되는 여행 포스트 카드 위젯.
///
/// - 카드 본체 탭 → [CommunityPostDetailScreen] 전체 페이지로 이동
/// - 좋아요 버튼 탭 → 토글 + 카운트 증감
class TravelPostCard extends StatefulWidget {
  /// [PostData]로부터 카드를 만드는 생성자
  const TravelPostCard({required this.post, super.key});

  /// 표시할 포스트 데이터
  final PostData post;

  @override
  State<TravelPostCard> createState() => _TravelPostCardState();
}

class _TravelPostCardState extends State<TravelPostCard> {
  late int _likeCount;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.initialLikeCount;
  }

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

  void _openDetail() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _PostDetailDialog(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _openDetail,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(post.profileImageUrl),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    post.timeAgo,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 4),
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
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey<bool>(_isLiked),
                          color: _isLiked
                              ? Colors.red
                              : const Color(0xFF212121),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_likeCount',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline, size: 22),
              const SizedBox(width: 12),
              const Icon(Icons.send, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 댓글 모델 ────────────────────────────────────────────────

class _Comment {
  const _Comment({
    required this.author,
    required this.text,
    required this.timeAgo,
  });

  final String author;
  final String text;
  final String timeAgo;
}

// ─── 커뮤니티 게시물 상세 전체 페이지 ──────────────────────────

/// 커뮤니티 게시물 상세 전체 화면 (바텀시트 대신 full page)
class CommunityPostDetailScreen extends StatefulWidget {
  /// [CommunityPostDetailScreen] 생성자
  const CommunityPostDetailScreen({required this.post, super.key});

  /// 표시할 포스트 데이터
  final PostData post;

  @override
  State<CommunityPostDetailScreen> createState() =>
      _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState
    extends State<CommunityPostDetailScreen> {
  final _inputController = TextEditingController();
  late int _likeCount;
  bool _isLiked = false;

  final _comments = <_Comment>[
    const _Comment(
      author: 'kim_traveler',
      text: '좋은 정보 감사합니다! 다음 주에 가볼 예정인데 참고할게요 :)',
      timeAgo: '1시간 전',
    ),
    const _Comment(
      author: 'osaka_lover',
      text: '사진 너무 예쁘네요. 어떤 카메라 쓰셨어요?',
      timeAgo: '30분 전',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.initialLikeCount;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

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

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(_Comment(author: '나', text: text, timeAgo: '방금'));
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── 상단 이미지 SliverAppBar ──
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {},
                      tooltip: '공유',
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFCFD8DC),
                            child: const Icon(Icons.image_not_supported,
                                size: 60, color: Colors.white),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x55000000),
                                Colors.transparent,
                                Color(0x88000000),
                              ],
                              stops: [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 작성자 정보 ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              NetworkImage(post.profileImageUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                post.timeAgo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 좋아요 버튼
                        InkWell(
                          onTap: _toggleLike,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 180),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                          scale: anim, child: child),
                                  child: Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    key: ValueKey<bool>(_isLiked),
                                    color: _isLiked
                                        ? Colors.red
                                        : const Color(0xFF212121),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_likeCount',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 제목 & 본문 ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          post.content ??
                              '아직 준비 중인 상세 내용입니다.\n추후 서버 또는 로컬 DB와 연동하여 본문을 표시할 예정입니다.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Divider(color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // ── 댓글 헤더 ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        const Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_comments.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF617C89),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 댓글 목록 ──
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _CommentTile(comment: _comments[index]),
                    ),
                    childCount: _comments.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),

          // ── 댓글 입력 바 (하단 고정) ──
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _inputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          hintStyle:
                              TextStyle(color: Color(0xFFAAAAAA)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF004AAD),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 댓글 타일 ────────────────────────────────────────────────

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final _Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            child: Text(
              comment.author.characters.first,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 모달 다이얼로그 (게시물 상세) ────────────────────────────

class _PostDetailDialog extends StatefulWidget {
  const _PostDetailDialog({required this.post});

  final PostData post;

  @override
  State<_PostDetailDialog> createState() => _PostDetailDialogState();
}

class _PostDetailDialogState extends State<_PostDetailDialog> {
  final _inputController = TextEditingController();
  late int _likeCount;
  bool _isLiked = false;

  final _comments = <_Comment>[
    const _Comment(
      author: 'kim_traveler',
      text: '좋은 정보 감사합니다! 다음 주에 가볼 예정인데 참고할게요 :)',
      timeAgo: '1시간 전',
    ),
    const _Comment(
      author: 'osaka_lover',
      text: '사진 너무 예쁘네요. 어떤 카메라 쓰셨어요?',
      timeAgo: '30분 전',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.initialLikeCount;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(_Comment(author: '나', text: text, timeAgo: '방금'));
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: screenHeight * 0.88,
        child: Column(
          children: [
            // ── 상단: 이미지 + 닫기 버튼 ──
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFCFD8DC),
                      child: const Icon(Icons.image_not_supported,
                          size: 48, color: Colors.white),
                    ),
                  ),
                ),
                // 그라디언트 오버레이
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
                // 닫기 버튼
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            // ── 스크롤 가능한 본문 영역 ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 작성자 + 좋아요
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(post.profileImageUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                post.timeAgo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 좋아요 버튼
                        InkWell(
                          onTap: _toggleLike,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 180),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                          scale: anim, child: child),
                                  child: Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    key: ValueKey<bool>(_isLiked),
                                    color: _isLiked
                                        ? Colors.red
                                        : const Color(0xFF212121),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_likeCount',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 제목 + 본문
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.content ??
                              '아직 준비 중인 상세 내용입니다.\n추후 서버 또는 로컬 DB와 연동하여 본문을 표시할 예정입니다.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.7,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // 댓글 헤더
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Row(
                      children: [
                        const Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_comments.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF617C89),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 댓글 목록
                  for (final c in _comments)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _CommentTile(comment: c),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // ── 댓글 입력바 (모달 하단 고정) ──
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                8,
                12,
                8 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _inputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF004AAD),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 피드 위젯 ────────────────────────────────────────────────

/// [travelPostsProvider]를 구독해 [TravelPostCard] 목록을 렌더링하는 피드.
class TravelPostFeed extends ConsumerWidget {
  /// [TravelPostFeed] 생성자
  const TravelPostFeed({super.key, this.showHeader = true});

  /// 상단 섹션 헤더("여행자 이야기") 표시 여부
  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(travelPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '여행자 이야기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
        postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('표시할 포스트가 없습니다.'),
              );
            }
            return Column(
              children: [
                for (final post in posts)
                  TravelPostCard(key: ValueKey(post.id), post: post),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              '포스트를 불러오지 못했습니다.\n$err',
              style:
                  const TextStyle(color: Color(0xFF617C89), fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
