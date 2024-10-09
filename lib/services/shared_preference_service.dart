// ignore_for_file: type_literal_in_constant_pattern

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static final instance = SharedPreferenceService._();

  SharedPreferenceService();

  SharedPreferenceService._();

  final _prefs = SharedPreferencesAsync();

  Map<String, Object?> cache = {};
  Future<void> fetchLocalData() async {
    cache = await _prefs.getAll();
  }

  Future<T?> get<T extends Object>(String key) async => switch (T) {
        String => await _prefs.getString(key),
        int => await _prefs.getInt(key),
        double => await _prefs.getDouble(key),
        bool => await _prefs.getBool(key),
        List => await _prefs.getStringList(key),
        _ => throw UnimplementedError(),
      } as T?;

  Future<void> set<T extends Object>(String key, T value) async {
    var _ = switch (T) {
      String => await _prefs.setString(key, value as String),
      int => await _prefs.setInt(key, value as int),
      double => await _prefs.setDouble(key, value as double),
      bool => await _prefs.setBool(key, value as bool),
      List => await _prefs.setStringList(key, List<String>.from(value as List)),
      _ => throw UnimplementedError(),
    };

    cache[key] = value;
  }

  Future<void> clear() async => await _prefs.clear();

  Future<void> remove(String key) async => await _prefs.remove(key);
}

enum SharedPreferenceKey {
  LATEST_IN_APP_REVIEW_TIME,
  LATEST_FEEDBACK_TIME,
  IS_FIRST_LAUNCH;
}
