import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/analytics/analytics.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final sudokuController = context.read<SudokuController>();
        Analytics.instance.logEvent(AnalyticEvent.PAUSED, properties: {
          'duration': sudokuController.timeElapsed.toString(),
          'boardID': sudokuController.board!.id.toString(),
        });
        sudokuController.pauseTimer();
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Game Paused'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Resume'),
              )
            ],
          ),
        );
        if (context.mounted) {
          context.read<SudokuController>().startTimer();
        }
      },
      padding: const EdgeInsets.all(4),
      icon: Assets.icons.pause.image(),
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
