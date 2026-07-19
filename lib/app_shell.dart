import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/core/themes/app_responsive.dart';
import 'package:template/features/community/screens/community_screen.dart';
import 'package:template/features/hanill/screens/hanill_screen.dart';
import 'package:template/features/home/screens/home_screen.dart';
import 'package:template/features/mypage/screens/mypage_screen.dart';
import 'package:template/features/schedule/screens/schedule_screen.dart';

/// Notifier to manage the current index of the BottomNavigationBar.
class AppShellIndex extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}

/// Provider to manage the current index of the BottomNavigationBar.
final appShellIndexProvider = NotifierProvider<AppShellIndex, int>(
  AppShellIndex.new,
);

/// AppShell is the main application shell that holds the bottom navigation bar
/// and the currently selected screen.
class AppShell extends ConsumerWidget {
  /// Creates an AppShell widget.
  const AppShell({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    ScheduleScreen(),
    HanillScreen(),
    CommunityScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current index.
    final currentIndex = ref.watch(appShellIndexProvider);

    // 웹/데스크톱 와이드 화면: 좌측 NavigationRail 레이아웃
    if (context.isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                ref.read(appShellIndexProvider.notifier).setIndex(index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  label: Text('홈'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_note_outlined),
                  label: Text('일정'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.api_outlined),
                  label: Text('한일'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.forum_outlined),
                  label: Text('커뮤니티'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  label: Text('마이'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: _screens[currentIndex],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 모바일/좁은 화면: 하단 탭 레이아웃
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // Update the provider's state on tap.
          ref.read(appShellIndexProvider.notifier).setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.api_outlined),
            label: '한일',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이',
          ),
        ],
      ),
    );
  }
}
