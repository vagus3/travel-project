import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app_shell.dart';
import 'package:template/core/controllers/theme_controller.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/setup.dart';

/// 앱 시작점
void main() {
  runZonedGuarded<Future<void>>(
    () async {
      // Flutter 바인딩 초기화
      WidgetsFlutterBinding.ensureInitialized();

      // Edge-to-edge: 앱이 상태바·네비게이션바 뒤까지 그려지도록 설정
      // → Scaffold + SafeArea 가 자동으로 시스템 inset을 처리합니다.
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // 라이트 테마 기준
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // 외부 서비스 초기화
      await AppSetup.initialize();
      // 다국어 지원 초기화
      await EasyLocalization.ensureInitialized();
      // Google Fonts 초기화
      await GoogleFonts.pendingFonts();

      runApp(
        // Riverpod 및 EasyLocalization 설정
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
