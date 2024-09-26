import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/share/controller/share_controller.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class BoardCompletedCard extends StatelessWidget {
  const BoardCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations!!'),
            const Text('You\'ve successfuly solved this puzzle!!'),
            SizedBox(height: size.height / 12),
            Card(
              margin: EdgeInsets.symmetric(horizontal: size.width / 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStat(
                    'Level',
                    context.read<SudokuController>().currentDifficulty.name,
                  ),
                  _buildStat(
                    'Time taken',
                    _formatDuration(
                        context.read<SudokuController>().timeElapsed),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height / 12),
            const Text(
              'Challenge your friends with the same board and see if they can do better.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff454545),
              ),
            ),
            FilledButton(
              onPressed: () {
                ShareController.shareCompleteBoard(
                    context.read<SudokuController>().board!,
                    _formatDuration(
                        context.read<SudokuController>().timeElapsed));
              },
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String val) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(val),
          ],
        ),
      );

  String _formatDuration(Duration duration) {
    // Extract hours, minutes, and seconds from the duration
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours =
        duration.inHours < 1 ? '' : '${twoDigits(duration.inHours)}:';
    String minutes = duration.inMinutes < 1
        ? ''
        : '${twoDigits(duration.inMinutes.remainder(60))}:';
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    // Return formatted string
    return "$hours$minutes$seconds";
  }
}
