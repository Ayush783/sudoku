import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/ad/widgets/sudoku_native_ad.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/painter/sudoku_board_painter.dart';
import 'package:sudoku/sudoku/view/widgets/board_completed_card.dart';
import 'package:sudoku/sudoku/view/widgets/difficulty_dropdown.dart';
import 'package:sudoku/sudoku/view/widgets/game_timer.dart';
import 'package:sudoku/sudoku/view/widgets/number_input_button.dart';
import 'package:sudoku/sudoku/view/widgets/pause_button.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board_cell.dart';
import 'package:sudoku/sudoku/view/widgets/tool_bar.dart';

class SudokuBoard extends StatelessWidget {
  const SudokuBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final board = context
        .select<SudokuController, SudokuBoardModel?>((value) => value.board);
    final isBoardCompleted = context
        .select<SudokuController, bool>((value) => value.isBoardCompleted);

    if (isBoardCompleted) {
      return const BoardCompletedCard();
    }

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    5,
                    (index) => NumberInputButton(value: index + 1),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (index) => NumberInputButton(value: index + 6),
                  ),
                ),
              ),
              SizedBox(height: 16),
              const ToolBar(),
              const Spacer(),
              const SudokuNativeAd(),
            ],
          )
        : const SizedBox.shrink();
  }
}
