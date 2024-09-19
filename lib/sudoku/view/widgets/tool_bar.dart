import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              final controller = context.read<SudokuController>();
              if (!controller.hasFocussedCell) return;
              controller.updateCell(0);
            },
            child: const Icon(Icons.backspace_outlined),
          ),
          const _NoteModeToggleButton(),
          ElevatedButton(
            onPressed: () {
              context.read<SudokuController>().undo();
            },
            child: const Icon(Icons.undo),
          ),
        ],
      ),
    );
  }
}

class _NoteModeToggleButton extends StatelessWidget {
  const _NoteModeToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isNoteModeOn =
        context.select<SudokuController, bool>((value) => value.noteModeOn);
    return ElevatedButton(
      onPressed: () {
        final val = context.read<SudokuController>().noteModeOn;
        context.read<SudokuController>().noteModeOn = !val;
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.edit),
          Positioned(
            bottom: 1,
            left: 12,
            child: Text(
              isNoteModeOn ? 'ON' : 'OFF',
              style: const TextStyle(
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
