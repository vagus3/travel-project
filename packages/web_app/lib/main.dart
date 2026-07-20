import 'dart:async';

import 'package:core/core/controllers/theme_controller.dart';
import 'package:core/core/themes/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_app/app_shell.dart';
import 'package:web_app/setup.dart';

/// 앱 시작점
void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 외부 서비스 초기화
      await AppSetup.initialize();
      // 다국어 지원 초기화
      await EasyLocalization.ensureInitialized();
      // Google Fonts 초기화
      await GoogleFonts.pendingFonts();

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('ko'), Locale('en'), Locale('ja')],
          path: 'assets/translations',
          fallbackLocale: const Locale('ko'),
          child: const ProviderScope(child: MyApp()),
        ),
      );
    },
    AppSetup.handleZoneError,
  );
}

/// 앱의 루트 위젯
class MyApp extends ConsumerWidget {
  /// MyApp 생성자
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp(
      title: 'travel-project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const AppShell(),
    );
  }
}
