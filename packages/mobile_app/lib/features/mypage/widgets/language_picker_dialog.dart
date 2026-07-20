import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';

class _LanguageOption {
  const _LanguageOption({required this.label, required this.locale});

  final String label;
  final Locale locale;
}

/// 앱 언어를 선택하는 다이얼로그.
///
/// 한국어 / English / 日本語 중 하나를 선택하면 [EasyLocalization]을 통해
/// 즉시 앱 전체 로케일이 변경됩니다.
class LanguagePickerDialog extends StatelessWidget {
  /// [LanguagePickerDialog] 생성자
  const LanguagePickerDialog({super.key});

  static const _options = <_LanguageOption>[
    _LanguageOption(label: '한국어', locale: Locale('ko')),
    _LanguageOption(label: 'English', locale: Locale('en')),
    _LanguageOption(label: '日本語', locale: Locale('ja')),
  ];

  /// 호출 헬퍼.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const LanguagePickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentLocale = context.locale;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                '언어 선택',
                style: AppTypography.bodyBold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            Divider(height: 1, color: colors.border),
            for (final option in _options)
              _LanguageTile(
                option: option,
                isSelected: option.locale == currentLocale,
                onTap: () async {
                  await context.setLocale(option.locale);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: AppTypography.label.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? colors.textPrimary : colors.textSecondary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 20, color: colors.textPrimary),
          ],
        ),
      ),
    );
  }
}
