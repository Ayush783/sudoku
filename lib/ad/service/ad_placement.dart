import 'package:flutter/foundation.dart';

enum AdPlacement {
  nativeHome_1,
  nativeBoard_1;

  String get adUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/2247696110'
      : switch (this) {
          nativeHome_1 => 'ca-app-pub-5712058463720831/8489974585',
          nativeBoard_1 => 'ca-app-pub-5712058463720831/1215778357',
        };
}
