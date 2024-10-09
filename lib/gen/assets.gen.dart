/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/backspace.png
  AssetGenImage get backspace =>
      const AssetGenImage('assets/icons/backspace.png');

  /// File path: assets/icons/edit.png
  AssetGenImage get edit => const AssetGenImage('assets/icons/edit.png');

  /// File path: assets/icons/light-bulb.png
  AssetGenImage get lightBulb =>
      const AssetGenImage('assets/icons/light-bulb.png');

  /// File path: assets/icons/mingcute_delete-line.png
  AssetGenImage get mingcuteDeleteLine =>
      const AssetGenImage('assets/icons/mingcute_delete-line.png');

  /// File path: assets/icons/pause.png
  AssetGenImage get pause => const AssetGenImage('assets/icons/pause.png');

  /// File path: assets/icons/playstore.png
  AssetGenImage get playstore =>
      const AssetGenImage('assets/icons/playstore.png');

  /// File path: assets/icons/send.png
  AssetGenImage get send => const AssetGenImage('assets/icons/send.png');

  /// File path: assets/icons/undo.png
  AssetGenImage get undo => const AssetGenImage('assets/icons/undo.png');

  /// File path: assets/icons/whatsapp.png
  AssetGenImage get whatsapp =>
      const AssetGenImage('assets/icons/whatsapp.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        backspace,
        edit,
        lightBulb,
        mingcuteDeleteLine,
        pause,
        playstore,
        send,
        undo,
        whatsapp
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
