import 'package:flutter/material.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/services/google_play_instant_service.dart';

class InstantAppInstallButton extends StatefulWidget {
  const InstantAppInstallButton({super.key});

  @override
  State<InstantAppInstallButton> createState() =>
      _InstantAppInstallButtonState();
}

class _InstantAppInstallButtonState extends State<InstantAppInstallButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GooglePlayInstantService.instance.isInstantApp
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FilledButton(
              onPressed: () {
                GooglePlayInstantService.instance.showInstallPrompt();
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
