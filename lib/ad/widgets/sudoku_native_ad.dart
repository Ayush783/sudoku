import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku/ad/service/ad_placement.dart';
import 'package:sudoku/ad/service/ad_service.dart';

class SudokuNativeAd extends StatefulWidget {
  const SudokuNativeAd({super.key});

  @override
  State<SudokuNativeAd> createState() => SudokuNativeAdState();
}

class SudokuNativeAdState extends State<SudokuNativeAd> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  Timer? _adRefreshTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        loadAd();
        refreshAdEvery30Seconds();
      },
    );
    super.initState();
  }

  void refreshAdEvery30Seconds() async {
    _adRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      loadAd();
    });
  }

  void loadAd() {
    if (_nativeAd != null) {
      _nativeAd!.dispose();
      _nativeAd = null;
    }

    _nativeAd = AdService.initializeNativeAd(
      AdPlacement.nativeBoard_1,
      onAdLoaded: () => setState(() {
        _nativeAdIsLoaded = true;
      }),
    )..load();
  }

  @override
  void dispose() {
    _adRefreshTimer?.cancel();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return _nativeAdIsLoaded
        ? ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: width - 32,
              minHeight: 60,
              maxWidth: width,
              maxHeight: 90,
            ),
            child: AdWidget(key: ValueKey(_nativeAd.hashCode), ad: _nativeAd!),
          )
        : const SizedBox.shrink();
  }
}
