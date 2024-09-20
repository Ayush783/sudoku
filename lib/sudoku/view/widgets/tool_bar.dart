import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/hint_type.dart';
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
          const _HintButton(),
          ElevatedButton(
            onPressed: () {
              context.read<SudokuController>().undo();
            },
            child: const Icon(Icons.undo_outlined),
          ),
        ],
      ),
    );
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final hintTypeCounter =
            context.read<SudokuController>().hintTypeCounter;

        final hintType = await showModalBottomSheet<HintType?>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: HintType.values
                  .map(
                    (e) => FilledButton(
                      onPressed: () {
                        if (hintTypeCounter[e]! > 0) {
                          Navigator.pop(context, e);
                        } else {
                          // TODO: show rewarded ad
                        }
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(switch (e) {
                            HintType.cell => 'Reveal a single cell',
                            HintType.row => 'Reveal a single row',
                            HintType.block => 'Reveal a single block',
                          }),
                          const SizedBox(width: 4),
                          Badge(
                            label: Text(
                              hintTypeCounter[e]! > 0
                                  ? hintTypeCounter[e].toString()
                                  : 'AD',
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );

        if (context.mounted && hintType != null) {
          context.read<SudokuController>().takeHint(hintType);
        }
      },
      child: const Icon(
        Icons.lightbulb_outline_rounded,
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
          const Icon(Icons.edit_outlined),
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
