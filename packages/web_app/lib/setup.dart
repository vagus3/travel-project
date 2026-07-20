import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 웹 앱 초기화
///
/// 모바일과 달리 Firebase/FCM/로컬 알림은 사용하지 않고, 환경 변수 로드만 수행합니다.
class AppSetup {
  /// 앱 초기화
  static Future<void> initialize() async {
    await dotenv.load();
  }

  /// Zone 에러 핸들러
  static void handleZoneError(Object error, StackTrace stack) {
    // ignore: avoid_print
    print('Uncaught error: $error\n$stack');
  }
}
