import 'package:flutter/foundation.dart';

enum AdPlacement {
  nativeBanner_1,
  nativeBoard_1,
  reward;

  String get adUnitId => switch (this) {
        nativeBanner_1 => kDebugMode
            ? 'ca-app-pub-3940256099942544/9214589741'
            : 'ca-app-pub-5712058463720831/2129950911',
        nativeBoard_1 => kDebugMode
            ? 'ca-app-pub-3940256099942544/2247696110'
            : 'ca-app-pub-5712058463720831/1215778357',
        reward => kDebugMode
            ? 'ca-app-pub-3940256099942544/5354046379'
            : 'ca-app-pub-5712058463720831/5629041365',
      };
}
