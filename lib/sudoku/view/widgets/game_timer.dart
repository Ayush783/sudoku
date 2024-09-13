import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  @override
  Widget build(BuildContext context) {
    final timeElapsed = context
        .select<SudokuController, Duration>((value) => value.timeElapsed);
    return Text(_formatDuration(timeElapsed));
  }

  String _formatDuration(Duration duration) {
    // Extract hours, minutes, and seconds from the duration
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String prefix = duration.inMinutes < 1
        ? 's'
        : duration.inHours < 1
            ? 'm'
            : 'h';
    String hours =
        duration.inHours < 1 ? '' : '${twoDigits(duration.inHours)}:';
    String minutes = duration.inMinutes < 1
        ? ''
        : '${twoDigits(duration.inMinutes.remainder(60))}:';
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    // Return formatted string
    return "$hours$minutes$seconds$prefix";
  }
}
