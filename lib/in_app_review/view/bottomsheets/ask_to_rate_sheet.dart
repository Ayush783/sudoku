import 'package:flutter/material.dart';
import 'package:sudoku/gen/assets.gen.dart';

class AskToRateSheet extends StatelessWidget {
  const AskToRateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please rate us on the Play Store! Your support means a lot to us.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rate us!',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Assets.icons.playstore
                        .image(height: 20, color: Colors.white),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
