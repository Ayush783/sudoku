import 'package:flutter/foundation.dart';

enum AdPlacement {
  nativeBoard_1;

  String get adUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/2247696110'
      : switch (this) {
          nativeBoard_1 => 'ca-app-pub-5712058463720831/1215778357',
        };
}
