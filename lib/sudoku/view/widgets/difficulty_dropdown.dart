import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_difficulty.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board_cell.dart';

class DifficultyDropdown extends StatefulWidget {
  const DifficultyDropdown({super.key});

  @override
  State<DifficultyDropdown> createState() => _DifficultyDropdownState();
}

class _DifficultyDropdownState extends State<DifficultyDropdown> {
  @override
  Widget build(BuildContext context) {
    final currentDifficulty =
        context.select<SudokuController, SudokuDifficulty>(
            (value) => value.currentDifficulty);
    return DropdownButton<SudokuDifficulty>(
      value: currentDifficulty,
      underline: const SizedBox.shrink(),
      isDense: true,
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: SudokuDifficulty.values
          .map(
            (e) => DropdownMenuItem<SudokuDifficulty>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
      onChanged: (val) async {
        if (val == null) return;

        bool shouldReset = true;

        if (context.read<SudokuController>().hasProgress) {
          shouldReset = await showDialog(
            context: context,
            builder: (context) => _alertDialog,
          );
        }

        if (shouldReset && mounted) {
          context.read<SudokuController>().currentDifficulty = val;
        }
      },
    );
  }

  AlertDialog get _alertDialog => AlertDialog(
        title: const Text(
          'Reset Game?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Changing difficulty will reset current progress.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('No'),
          ),
        ],
      );
}
