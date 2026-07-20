import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/hanill/controllers/hanill_controller.dart';
import 'package:core/features/hanill/models/hanill_model.dart';
import 'package:core/features/schedule/controllers/schedule_controller.dart';
import 'package:core/features/schedule/models/schedule_model.dart';
import 'package:mobile_app/features/schedule/screens/schedule_detail_screen.dart';

const _sidebarWidth = 280.0;

/// 한일이 AI 채팅 화면
class HanillScreen extends ConsumerStatefulWidget {
  /// [HanillScreen] 생성자
  const HanillScreen({super.key});

  @override
  ConsumerState<HanillScreen> createState() => _HanillScreenState();
}

class _HanillScreenState extends ConsumerState<HanillScreen>
    with TickerProviderStateMixin {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  late final AnimationController _bgController;
  late final AnimationController _typewriterController;
  late final AnimationController _cursorController;
  var _isSidebarOpen = false;

  static const _suggestions = ['후쿠오카 활동 추천', '오사카 3박 4일 일정', '나가사키 호텔 추천'];

  /// 환영 메시지에 표시할 사용자 이름 (TODO: 실제 사용자 상태로 대체)
  static const _userName = '김여행';
  static const _welcomeMessage =
      '안녕하세요 $_userName님.\n오늘은 어떤 여행을 계획하실건가요?';

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70 * _welcomeMessage.length),
    )..forward();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _bgController.dispose();
    _typewriterController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      return;
    }
    _inputController.clear();
    ref.read(hanillControllerProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addToSchedule(BuildContext context, GeneratedSchedule generated) {
    final details = generated.days
        .expand(
          (day) => day.places.map(
            (p) => ScheduleDetail(
              day: day.day,
              time: p.time,
              placeName: p.placeName,
              description: p.description,
              imageUrl: '',
              lat: p.lat,
              lng: p.lng,
            ),
          ),
        )
        .toList();

    final summary = ScheduleSummary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: generated.title,
      dateRange: '${generated.startDate} ~ ${generated.endDate}',
      imageUrl: '',
      location: generated.location,
      details: details,
    );

    ref.read(scheduleControllerProvider.notifier).addSchedule(summary);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScheduleDetailScreen(schedule: summary),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) {
      return '방금 전';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}분 전';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}시간 전';
    }
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(hanillControllerProvider);

    if (state.isLoading) {
      _scrollToBottom();
    }

    return Stack(
      children: [
        // 메인 채팅 영역 (움직이는 그라데이션 배경)
        _buildAnimatedBackground(
          child: Column(
            children: [
              _buildTopBar(colors, state),
              Expanded(
                child: state.currentMessages.isEmpty
                    ? _buildWelcome(colors)
                    : _buildChatList(colors, state),
              ),
              _buildInputBar(colors, state.isLoading),
            ],
          ),
        ),

        // 오버레이 (사이드바 열릴 때)
        if (_isSidebarOpen)
          GestureDetector(
            onTap: () => setState(() => _isSidebarOpen = false),
            child: const ColoredBox(
              color: Color(0x55000000),
              child: SizedBox.expand(),
            ),
          ),

        // 사이드바 패널
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          left: _isSidebarOpen ? 0 : -_sidebarWidth,
          top: 0,
          bottom: 0,
          width: _sidebarWidth,
          child: _buildSidebar(colors, state),
        ),
      ],
    );
  }

  /// 분홍 톤의 일렁이는 그라데이션 배경 (한일이 전용 브랜드 배경 — 테마 무관 고정)
  Widget _buildAnimatedBackground({required Widget child}) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        final t = _bgController.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 0.6, -1 + t * 0.4),
              end: Alignment(1 - t * 0.6, 1 - t * 0.4),
              colors: const [
                Color(0xFFFFF1F4),
                Color(0xFFFCD8E1),
                Color(0xFFFFE4F0),
                Color(0xFFFBC8D7),
              ],
              stops: [
                0,
                0.25 + 0.15 * t,
                0.6 + 0.15 * (1 - t),
                1,
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }

  Widget _buildTopBar(AppColors colors, HanillState state) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.highlight.withValues(alpha: 0.1)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu_rounded, color: colors.highlight),
                onPressed: () => setState(() => _isSidebarOpen = true),
              ),
              Expanded(
                child: Text(
                  state.activeThread?.title ?? '한일이',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyBold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colors.highlight),
                tooltip: '새 대화',
                onPressed: () {
                  ref.read(hanillControllerProvider.notifier).createNewThread();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(AppColors colors, HanillState state) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 사이드바 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '대화 기록',
                      style: AppTypography.subtitle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isSidebarOpen = false),
                  ),
                ],
              ),
            ),

            // 새 대화 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: FilledButton.icon(
                onPressed: () {
                  ref
                      .read(hanillControllerProvider.notifier)
                      .createNewThread();
                  setState(() => _isSidebarOpen = false);
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('새 대화'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.highlight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 4),

            // 스레드 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: state.threads.length,
                itemBuilder: (context, index) =>
                    _buildThreadItem(colors, state, state.threads[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadItem(AppColors colors, HanillState state, ChatThread thread) {
    final isActive = thread.id == state.activeThreadId;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? colors.highlight.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            ref
                .read(hanillControllerProvider.notifier)
                .switchThread(thread.id);
            setState(() => _isSidebarOpen = false);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isActive
                              ? colors.highlight
                              : colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _timeAgo(thread.createdAt),
                        style: AppTypography.micro.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: colors.textMuted,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: colors.error),
                          const SizedBox(width: 8),
                          Text(
                            '삭제',
                            style: TextStyle(color: colors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      ref
                          .read(hanillControllerProvider.notifier)
                          .deleteThread(thread.id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome(AppColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: AnimatedBuilder(
          animation: Listenable.merge([_typewriterController, _cursorController]),
          builder: (_, _) {
            final length =
                (_welcomeMessage.length * _typewriterController.value).round();
            final visible = _welcomeMessage.substring(0, length);
            final isTyping = !_typewriterController.isCompleted;
            final cursorVisible = isTyping || _cursorController.value > 0.5;

            return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.title.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: visible),
                  TextSpan(
                    text: '|',
                    style: TextStyle(
                      color: cursorVisible
                          ? colors.highlight
                          : Colors.transparent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatList(AppColors colors, HanillState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: state.currentMessages.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.currentMessages.length) {
          return _buildTypingIndicator(colors);
        }
        return _buildMessageBubble(context, colors, state.currentMessages[index]);
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    AppColors colors,
    ChatMessage message,
  ) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colors.highlight,
                  child: Text(
                    '한',
                    style: AppTypography.small.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isUser ? colors.highlight : colors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      message.content,
                      style: AppTypography.body.copyWith(
                        color: isUser ? Colors.white : colors.textPrimary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),
          if (message.generatedSchedule != null) ...[
            const SizedBox(height: 8),
            _buildScheduleCard(context, colors, message.generatedSchedule!),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    AppColors colors,
    GeneratedSchedule schedule,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 40),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.highlight.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: colors.highlight, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  schedule.title,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${schedule.startDate} ~ ${schedule.endDate}  ·  ${schedule.days.length}일',
            style: AppTypography.small.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _addToSchedule(context, schedule),
              style: FilledButton.styleFrom(
                backgroundColor: colors.highlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                '일정에 추가하기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colors.highlight,
            child: Text(
              '한',
              style: AppTypography.small.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DotIndicator(delay: 0, color: colors.highlight),
                  const SizedBox(width: 4),
                  _DotIndicator(delay: 200, color: colors.highlight),
                  const SizedBox(width: 4),
                  _DotIndicator(delay: 400, color: colors.highlight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(AppColors colors, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        children: [
          _buildSuggestionChips(colors),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _inputController,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: '일본 여행 계획을 세워주세요.',
                      hintStyle: TextStyle(color: colors.textMuted),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isLoading ? null : _send,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLoading
                        ? colors.highlight.withValues(alpha: 0.5)
                        : colors.highlight,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
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
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(AppColors colors) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final s = _suggestions[index];
          return GestureDetector(
            onTap: () {
              _inputController.text = s;
              _send();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colors.highlight.withValues(alpha: 0.4),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Text(
                  s,
                  style: AppTypography.label.copyWith(
                    color: colors.highlight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 타이핑 애니메이션 점 위젯
class _DotIndicator extends StatefulWidget {
  const _DotIndicator({required this.delay, required this.color});

  final int delay;
  final Color color;

  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _animController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.3 + _animation.value * 0.7),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(width: 8, height: 8),
      ),
    );
  }
}
