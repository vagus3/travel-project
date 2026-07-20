import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/community/screens/community_screen.dart';
import 'package:mobile_app/features/hanill/screens/hanill_screen.dart';
import 'package:mobile_app/features/home/screens/home_screen.dart';
import 'package:mobile_app/features/mypage/screens/mypage_screen.dart';
import 'package:mobile_app/features/schedule/screens/schedule_screen.dart';

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
