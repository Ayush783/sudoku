// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class AppLinksService {
  static const String CHANNEL_NAME = 'SUDOKU_APPLINKS_METHODCHANNEL';
  static const String _logName = 'AppLinksService';

  AppLinksService();

  static const MethodChannel _appLinksMethodChannel =
      MethodChannel(CHANNEL_NAME);

  static StreamController<Uri?>? _appLinksStreamController;

  /// Must not be accessed before [init] is called
  static Stream<Uri?>? get onLink => _appLinksStreamController!.stream;

  static final _completer = Completer<Uri>();

  static void init() {
    _appLinksStreamController = StreamController.broadcast();
    _appLinksMethodChannel.setMethodCallHandler(
      (call) async {
        if (call.method == 'onAppLinkOpened') {
          log(call.arguments, name: _logName);
          if (_appLinksStreamController?.hasListener ?? false) {
            _appLinksStreamController?.add(Uri.parse(call.arguments));
          } else {
            _completer.complete(Uri.parse(call.arguments));
          }
        }
      },
    );
  }

  static Future<Uri?> getAppLaunchedArticleId() async {
    try {
      Timer(const Duration(seconds: 3), () {
        _completer.completeError('Timed out');
      });
      return await _completer.future;
    } catch (e) {
      log('Error $e', name: _logName);
      return null;
    }
  }

  static void dispose() {
    _appLinksStreamController?.close();
  }
}
