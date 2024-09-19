import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/ad/widgets/sudoku_native_ad.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/widgets/difficulty_dropdown.dart';
import 'package:sudoku/sudoku/view/widgets/game_timer.dart';
import 'package:sudoku/sudoku/view/widgets/pause_button.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board_cell.dart';

class SudokuBoard extends StatelessWidget {
  const SudokuBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final board = context
        .select<SudokuController, SudokuBoardModel?>((value) => value.board);
    return board != null
        ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    DifficultyDropdown(),
                    Spacer(),
                    GameTimer(),
                    PauseButton(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomPaint(
                  painter: SudokuBoardPainter(),
                  child: Column(
                    children: board.cellMatrix
                        .map(
                          (row) => Row(
                            children: row
                                .map((e) => SudokuBoardCell(cell: e))
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 12,
                  spacing: 0,
                  children: List.generate(
                    9,
                    (index) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {
                        final controller = context.read<SudokuController>();

                        if (!controller.hasFocussedCell) return;

                        controller.updateCell(index + 1);
                      },
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final controller = context.read<SudokuController>();
                        if (!controller.hasFocussedCell) return;
                        controller.updateCell(0);
                      },
                      child: const Icon(Icons.do_disturb_alt_rounded),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SudokuController>().undo();
                      },
                      child: const Icon(Icons.undo),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SudokuNativeAd(),
            ],
          )
        : const SizedBox.shrink();
  }
}

class SudokuBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Grid dimensions
    double cellSize = size.width / 9;

    // Draw outer border
    final outerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw outer square
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.width), outerPaint);

    // Draw the 9x9 grid lines
    for (int i = 0; i <= 9; i++) {
      double position = i * cellSize;

      // Horizontal lines
      canvas.drawLine(Offset(0, position), Offset(size.width, position),
          i % 3 == 0 ? outerPaint : paint);

      // Vertical lines
      canvas.drawLine(Offset(position, 0), Offset(position, size.width),
          i % 3 == 0 ? outerPaint : paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
