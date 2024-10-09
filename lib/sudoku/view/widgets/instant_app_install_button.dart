import 'package:flutter/material.dart';
import 'package:google_play_instant/google_play_instant.dart';
import 'package:sudoku/gen/assets.gen.dart';

class InstantAppInstallButton extends StatefulWidget {
  const InstantAppInstallButton({super.key});

  @override
  State<InstantAppInstallButton> createState() =>
      _InstantAppInstallButtonState();
}

class _InstantAppInstallButtonState extends State<InstantAppInstallButton> {
  final GooglePlayInstant _playInstant = GooglePlayInstant();

  bool isInstantApp = false;
  @override
  void initState() {
    super.initState();
    isInstantAppGetter();
  }

  isInstantAppGetter() async {
    isInstantApp = (await _playInstant.isInstantApp()) ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isInstantApp
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FilledButton(
              onPressed: () {
                _playInstant.showInstallPrompt();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Install',
                    style: TextStyle(fontSize: 24),
                  ),
                  Assets.icons.playstore.image(height: 20, color: Colors.white),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
