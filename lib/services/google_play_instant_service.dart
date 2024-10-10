import 'package:google_play_instant/google_play_instant.dart';

class GooglePlayInstantService {
  static final instance = GooglePlayInstantService._();

  GooglePlayInstantService._();

  GooglePlayInstantService();

  final _googlePlayInstant = GooglePlayInstant();

  late final bool _isInstantApp;
  bool get isInstantApp => _isInstantApp;

  Future<void> init() async {
    _isInstantApp = (await _googlePlayInstant.isInstantApp()) ?? false;
  }

  void showInstallPrompt() => _googlePlayInstant.showInstallPrompt();
}
