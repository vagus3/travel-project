import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_app/firebase_options.dart';

/// 로컬 알림 플러그인 인스턴스 (앱 전역에서 접근 가능)
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Android 알림 채널
const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  '주요 알림',
  description: '여행 일정 및 중요 알림을 표시합니다.',
  importance: Importance.high,
);

/// FCM 백그라운드 메시지 핸들러 (top-level 함수여야 함)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('백그라운드 FCM 수신: ${message.messageId}');
  }
}

/// 앱 초기화 및 외부 서비스 설정
///
/// Firebase, Messaging, 로컬 알림 등 앱에서 사용하는 외부 서비스를 초기화합니다.
///
/// ## Firebase 설정
/// 템플릿 모드에서는 Firebase를 초기화하지 않습니다.
/// 실제 프로젝트에서 사용하려면:
/// 1. `flutterfire configure` 명령어 실행
/// 2. [enableFirebase] 상수를 true로 변경
class AppSetup {
  /// Firebase 활성화 여부
  static const enableFirebase = false;

  /// 앱 초기화
  static Future<void> initialize() async {
    await dotenv.load();
    await _initializeFirebase();
  }

  /// Firebase + Messaging + 로컬 알림 초기화
  static Future<void> _initializeFirebase() async {
    if (!enableFirebase) {
      if (kDebugMode) {
        print('Firebase가 비활성화되어 있습니다 (템플릿 모드)');
      }
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // ── Crashlytics ──
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // ── Firebase Messaging ──
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      await _initializeLocalNotifications();
      await _requestNotificationPermission();
      _listenForegroundMessages();

      if (kDebugMode) {
        final token = await FirebaseMessaging.instance.getToken();
        print('FCM Token: $token');
      }

      if (kDebugMode) {
        print('Firebase 초기화 완료');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Firebase 초기화 실패: $e\n$stack');
      }
      rethrow;
    }
  }

  /// 로컬 알림 초기화 (Android 채널 + iOS 설정)
  static Future<void> _initializeLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await flutterLocalNotificationsPlugin.initialize(settings: initSettings);

    // Android 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// 알림 권한 요청 (iOS + Android 13+)
  static Future<void> _requestNotificationPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission();
    if (kDebugMode) {
      print('알림 권한: ${result.authorizationStatus}');
    }
  }

  /// 포그라운드 FCM 메시지 리스너
  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification == null) {
        return;
      }

      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    });
  }

  /// Zone 에러 핸들러
  static void handleZoneError(Object error, StackTrace stack) {
    if (enableFirebase) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else if (kDebugMode) {
      print('Uncaught error: $error\n$stack');
    }
  }
}
