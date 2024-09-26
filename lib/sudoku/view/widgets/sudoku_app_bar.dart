import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/widgets/pause_button.dart';
import 'package:sudoku/sudoku/view/widgets/share_button.dart';

class SudokuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SudokuAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isBoardCompleted = context
        .select<SudokuController, bool>((value) => value.isBoardCompleted);
    return AppBar(
      title: const Text('Sudoku'),
      centerTitle: false,
      actions: isBoardCompleted ? [] : const [PauseButton(), ShareButton()],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
