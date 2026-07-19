import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps API Key 초기화
    // Google Cloud Console → Maps SDK for iOS 에서 발급한 키를 입력하세요.
    // https://console.cloud.google.com/apis/credentials
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
