// ignore_for_file: constant_identifier_names

import 'package:sudoku/analytics/firebase_analytics_service.dart';

abstract class Analytics {
  static final instance = FirebaseAnalyticsService();

  void logEvent(AnalyticEvent event, {Map<String, Object>? properties});
  Future<void> setDefaults();
}

enum AnalyticEvent {
  // params - boardID, duration
  PAUSED,
  AD_IMPRESSION,
  // Hint type
  HINT_TAKEN,
  USING_NOTES,
  UNDO,
  // boardID
  SHARE,
  // boardID
  COMPLETED,
  // boardID
  NEW_GAME;
}
