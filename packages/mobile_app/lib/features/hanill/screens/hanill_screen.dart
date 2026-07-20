import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/features/hanill/controllers/hanill_controller.dart';
import 'package:core/features/hanill/models/hanill_model.dart';
import 'package:core/features/schedule/controllers/schedule_controller.dart';
import 'package:core/features/schedule/models/schedule_model.dart';
import 'package:mobile_app/features/schedule/screens/schedule_detail_screen.dart';

const _primaryPink = Color(0xFFEE2B5B);
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
  static const _welcomeMessage = '안녕하세요 $_userName님.\n오늘은 어떤 여행을 계획하실건가요?';

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
              _buildTopBar(state),
              Expanded(
                child: state.currentMessages.isEmpty
                    ? _buildWelcome()
                    : _buildChatList(state),
              ),
              _buildInputBar(state.isLoading),
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
          child: _buildSidebar(state),
        ),
      ],
    );
  }

  /// 분홍 톤의 일렁이는 그라데이션 배경
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

  Widget _buildTopBar(HanillState state) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x1AEE2B5B)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: _primaryPink),
                onPressed: () => setState(() => _isSidebarOpen = true),
              ),
              Expanded(
                child: Text(
                  state.activeThread?.title ?? '한일이',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: _primaryPink),
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

  Widget _buildSidebar(HanillState state) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
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
                  const Expanded(
                    child: Text(
                      '대화 기록',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF888888),
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
                  ref.read(hanillControllerProvider.notifier).createNewThread();
                  setState(() => _isSidebarOpen = false);
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('새 대화'),
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryPink,
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
                    _buildThreadItem(state, state.threads[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadItem(HanillState state, ChatThread thread) {
    final isActive = thread.id == state.activeThreadId;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? _primaryPink.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            ref.read(hanillControllerProvider.notifier).switchThread(thread.id);
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isActive
                              ? _primaryPink
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _timeAgo(thread.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: Color(0xFF999999),
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '삭제',
                            style: TextStyle(color: Colors.redAccent),
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

  Widget _buildWelcome() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _typewriterController,
            _cursorController,
          ]),
          builder: (_, _) {
            final length =
                (_welcomeMessage.length * _typewriterController.value).round();
            final visible = _welcomeMessage.substring(0, length);
            final isTyping = !_typewriterController.isCompleted;
            final cursorVisible = isTyping || _cursorController.value > 0.5;

            return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: visible),
                  TextSpan(
                    text: '|',
                    style: TextStyle(
                      color: cursorVisible ? _primaryPink : Colors.transparent,
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

  Widget _buildChatList(HanillState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: state.currentMessages.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.currentMessages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(context, state.currentMessages[index]);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: _primaryPink,
                  child: Text(
                    '한',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isUser ? _primaryPink : Colors.white,
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
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF1A1A2E),
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
            _buildScheduleCard(context, message.generatedSchedule!),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, GeneratedSchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(left: 40),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryPink.withValues(alpha: 0.3)),
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
              const Icon(Icons.event_note, color: _primaryPink, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  schedule.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${schedule.startDate} ~ ${schedule.endDate}  ·  ${schedule.days.length}일',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _addToSchedule(context, schedule),
              style: FilledButton.styleFrom(
                backgroundColor: _primaryPink,
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

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: _primaryPink,
            child: Text(
              '한',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DotIndicator(delay: 0),
                  SizedBox(width: 4),
                  _DotIndicator(delay: 200),
                  SizedBox(width: 4),
                  _DotIndicator(delay: 400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        children: [
          _buildSuggestionChips(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    decoration: const InputDecoration(
                      hintText: '일본 여행 계획을 세워주세요.',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
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
                        ? _primaryPink.withValues(alpha: 0.5)
                        : _primaryPink,
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

  Widget _buildSuggestionChips() {
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _primaryPink.withValues(alpha: 0.4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    color: _primaryPink,
                    fontSize: 13,
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
  const _DotIndicator({required this.delay});

  final int delay;

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
          color: _primaryPink.withValues(alpha: 0.3 + _animation.value * 0.7),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(width: 8, height: 8),
      ),
    );
  }
}
