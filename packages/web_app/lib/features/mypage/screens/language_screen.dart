import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:core/core/themes/app_colors.dart';

class _LanguageOption {
  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.locale,
  });

  final String label;
  final String subtitle;
  final Locale locale;
}

/// 언어 설정 상세 화면
class LanguageScreen extends StatelessWidget {
  /// [LanguageScreen] 생성자
  const LanguageScreen({super.key});

  static const _options = <_LanguageOption>[
    _LanguageOption(label: '한국어', subtitle: 'Korean', locale: Locale('ko')),
    _LanguageOption(label: 'English', subtitle: 'English', locale: Locale('en')),
    _LanguageOption(label: '日本語', subtitle: 'Japanese', locale: Locale('ja')),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentLocale = context.locale;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          '언어 설정',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colors.border),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
            mainAxisSize: MainAxisSize.min,
            children: _options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = option.locale == currentLocale;
              final isLast = index == _options.length - 1;

              return Column(
                children: [
                  InkWell(
                    onTap: () => context.setLocale(option.locale),
                    borderRadius: BorderRadius.only(
                      topLeft: index == 0 ? const Radius.circular(16) : Radius.zero,
                      topRight: index == 0 ? const Radius.circular(16) : Radius.zero,
                      bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? colors.textPrimary
                                        : colors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  option.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.textPrimary,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          else
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.border),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast) Divider(height: 1, thickness: 1, color: colors.border),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
