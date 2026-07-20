import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/mypage/controllers/mypage_controller.dart';
import 'package:mobile_app/features/mypage/screens/edit_profile_screen.dart';
import 'package:mobile_app/features/mypage/screens/language_screen.dart';
import 'package:mobile_app/features/mypage/screens/policy_screen.dart';
import 'package:mobile_app/features/mypage/widgets/activity_list.dart';
import 'package:mobile_app/features/mypage/widgets/activity_tabs.dart';

///
class MyPageScreen extends ConsumerWidget {
  /// MyPage 화면
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedTabIndex = ref.watch(myPageControllerProvider);
    final controller = ref.read(myPageControllerProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '마이페이지',
          style: AppTypography.subtitle.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colors.border),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- 1. 프로필 섹션 ---
            _buildProfileSection(context, colors),

            const SizedBox(height: 24),

            // --- 2. 나의 활동 섹션 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                '나의 활동',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ActivityTabs(
                    selectedTabIndex: selectedTabIndex,
                    onTabSelected: controller.setTabIndex,
                  ),
                  const SizedBox(height: 12),
                  selectedTabIndex == 0
                      ? const ActivityList()
                      : Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text(
                            '저장한 장소가 없습니다.',
                            style: TextStyle(color: colors.textMuted),
                          ),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 3. 설정 섹션 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                '설정',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ),
            _buildMenuSection(context, colors, [
              _MenuData(Icons.notifications_none, '알림 설정'),
              _MenuData(
                Icons.language,
                '언어 설정',
                onTap: (ctx) => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LanguageScreen(),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // --- 4. 고객지원 섹션 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                '고객지원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ),
            _buildMenuSection(context, colors, [
              _MenuData(Icons.campaign_outlined, '공지사항'),
              _MenuData(Icons.support_agent, '문의하기'),
              _MenuData(
                Icons.gavel,
                '이용약관',
                onTap: (ctx) => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PolicyScreen(
                      title: '이용약관',
                      body: PolicyDocuments.termsOfService,
                    ),
                  ),
                ),
              ),
              _MenuData(
                Icons.privacy_tip_outlined,
                '개인정보이용방침',
                onTap: (ctx) => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PolicyScreen(
                      title: '개인정보이용방침',
                      body: PolicyDocuments.privacyPolicy,
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBESR1KbkKJJkYl6lOl4PACYqqvbse0eN8mYsRlzvQZy8ah_Pl3v-R5NvRjQZ5INGr4EcZekG-ZEzB3GLS6473IGywIyYcEOzRrrd6EFVKX34luFoe6etcHlx7fz8Pu1SxbGRnT0rIqJUUHE62Se8812U-qb7hPlXNnRhsNJVnnvDDG_fMLXfOMABQg9JnMpNpgbYxe41IdoX0H0VTCDFfPqQyzJHb7eF9XESd5YFRcfj_tyeNGbYd055XSCpksWjKfphPevn0XFX_7',
                    ),
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
                      '김여행',
                      style: AppTypography.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'traveler_kim@email.com',
                      style: AppTypography.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EditProfileScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '프로필 수정',
                    style: AppTypography.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    AppColors colors,
    List<_MenuData> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
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
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Icon(item.icon, color: colors.textMuted, size: 22),
                  title: Text(
                    item.title,
                    style: AppTypography.label.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colors.border,
                    size: 22,
                  ),
                  onTap: item.onTap == null ? null : () => item.onTap!(context),
                ),
                if (!isLast)
                  Divider(height: 1, thickness: 1, color: colors.border),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MenuData {
  _MenuData(this.icon, this.title, {this.onTap});

  final IconData icon;
  final String title;
  final void Function(BuildContext context)? onTap;
}
