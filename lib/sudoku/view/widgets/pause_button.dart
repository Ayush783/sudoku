import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        context.read<SudokuController>().pauseTimer();
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
      icon: const Icon(Icons.pause),
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
