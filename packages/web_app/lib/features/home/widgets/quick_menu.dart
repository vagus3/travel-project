import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:url_launcher/url_launcher.dart';

/// 홈 화면 퀵 메뉴 — 각 아이콘은 Agoda 관련 페이지로 연결됩니다.
class QuickMenuWidget extends StatelessWidget {
  /// [QuickMenuWidget] 생성자
  const QuickMenuWidget({super.key});

  static const _menus = <_QuickMenuItem>[
    _QuickMenuItem(icon: Icons.flight, label: '항공권', url: 'https://www.agoda.com/flights'),
    _QuickMenuItem(icon: Icons.hotel, label: '숙소', url: 'https://www.agoda.com/'),
    _QuickMenuItem(icon: Icons.local_activity, label: '투어·티켓', url: 'https://www.agoda.com/activities'),
    _QuickMenuItem(icon: Icons.directions_car, label: '렌터카', url: 'https://www.agoda.com/transport'),
    _QuickMenuItem(icon: Icons.security, label: '보험', url: 'https://www.agoda.com/'),
  ];

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('페이지를 열 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.hPad),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _menus.map((menu) => _buildItem(context, colors, menu)).toList(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, AppColors colors, _QuickMenuItem menu) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openUrl(context, menu.url),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Icon(menu.icon, color: colors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            menu.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickMenuItem {
  const _QuickMenuItem({required this.icon, required this.label, required this.url});

  final IconData icon;
  final String label;
  final String url;
}
