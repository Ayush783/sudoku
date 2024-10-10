import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sudoku/analytics/analytics.dart';
import 'package:sudoku/services/google_play_instant_service.dart';

class FirebaseAnalyticsService implements Analytics {
  static final _analyticsInstance = FirebaseAnalytics.instance;

  @override
  void logEvent(event, {Map<String, Object>? properties}) {
    _analyticsInstance.logEvent(name: event.name, parameters: properties);
  }

  @override
  Future<void> setDefaults() async {
    final appInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await _analyticsInstance.setDefaultEventParameters({
      'version': appInfo.version,
      'buildNumber': appInfo.buildNumber,
      'deviceId': deviceInfo.id,
      'fcmToken': fcmToken ?? '',
      'isInstantApp': GooglePlayInstantService.instance.isInstantApp,
    });
  }
}
