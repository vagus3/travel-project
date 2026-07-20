import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_app/features/community/screens/community_screen.dart';
import 'package:web_app/features/hanill/screens/hanill_screen.dart';
import 'package:web_app/features/home/screens/home_screen.dart';
import 'package:web_app/features/mypage/screens/mypage_screen.dart';
import 'package:web_app/features/schedule/screens/schedule_screen.dart';

/// 현재 선택된 네비게이션 인덱스를 관리하는 Notifier
class AppShellIndex extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  /// 선택된 인덱스 변경
  void setIndex(int index) {
    state = index;
  }
}

/// 현재 선택된 네비게이션 인덱스 Provider
final appShellIndexProvider = NotifierProvider<AppShellIndex, int>(
  AppShellIndex.new,
);

/// 웹 앱의 최상위 셸 — 좌측 상시 노출 네비게이션 + 중앙 콘텐츠 영역
class AppShell extends ConsumerWidget {
  /// AppShell 생성자
  const AppShell({super.key});

  static const _screens = [
    HomeScreen(),
    ScheduleScreen(),
    HanillScreen(),
    CommunityScreen(),
    MyPageScreen(),
  ];

  static const _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('홈'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.event_note_outlined),
      selectedIcon: Icon(Icons.event_note),
      label: Text('일정'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.api_outlined),
      selectedIcon: Icon(Icons.api),
      label: Text('한일'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.forum_outlined),
      selectedIcon: Icon(Icons.forum),
      label: Text('커뮤니티'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: Text('마이'),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appShellIndexProvider);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(appShellIndexProvider.notifier).setIndex(index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: _destinations,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _screens[currentIndex]),
        ],
      ),
    );
  }
}
