import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';

class MyPageMenuItem extends StatelessWidget {
  const MyPageMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      leading: Icon(icon, color: colors.textMuted, size: 22),
      title: Text(
        title,
        style: AppTypography.body.copyWith(color: colors.textPrimary),
      ),
      trailing: Icon(Icons.chevron_right, color: colors.textMuted),
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      visualDensity: const VisualDensity(vertical: -1),
    );
  }
}
