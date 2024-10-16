import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku/analytics/analytics.dart';
import 'package:sudoku/app_config/flavor.dart';
import 'package:sudoku/app_links/service/app_links_service.dart';
import 'package:sudoku/services/google_play_instant_service.dart';
import 'package:sudoku/services/shared_preference_service.dart';
import 'package:sudoku/sudoku/view/screens/sudoku_app.dart';

void main() async {
  Flavor.set(isInstant: false);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  AppLinksService.init();

  MobileAds.instance.initialize();

  await GooglePlayInstantService.instance.init();

  await Analytics.instance.setDefaults();

  await SharedPreferenceService.instance.fetchLocalData();

  runApp(const SudokuApp());
}
