import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class SudokuBoardCell extends StatefulWidget {
  const SudokuBoardCell({
    super.key,
    required this.cell,
  });
  final SudokuCellModel cell;

  @override
  State<SudokuBoardCell> createState() => _SudokuBoardCellState();
}

class _SudokuBoardCellState extends State<SudokuBoardCell> {
  SudokuCellModel get cell => widget.cell;
  late int r, g, b;

  @override
  void initState() {
    r = Random().nextInt(255);
    g = Random().nextInt(255);
    b = Random().nextInt(255);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isFocussedRow = context.select<SudokuController, bool>(
        (value) => value.focussedRow == cell.rowIndex);
    final isFocussedCol = context.select<SudokuController, bool>(
        (value) => value.focussedColumn == cell.colIndex);

    bool isFocussedBlock = context.select<SudokuController, bool>((value) {
      if (value.focussedRow == -1 || value.focussedColumn == -1) {
        return false;
      }

      final focussedBlockStartRow = 3 * (value.focussedRow ~/ 3);
      final focussedBlockStartColumn = 3 * (value.focussedColumn ~/ 3);
      return (focussedBlockStartRow <= cell.rowIndex &&
              cell.rowIndex < focussedBlockStartRow + 3) &&
          (focussedBlockStartColumn <= cell.colIndex &&
              cell.colIndex < focussedBlockStartColumn + 3);
    });

    final cellSize = kIsWeb
        ? _getSize(MediaQuery.sizeOf(context)) / 9
        : (MediaQuery.sizeOf(context).width - 32) / 9;
    final lastEnteredValue = context
        .select<SudokuController, int>((value) => value.lastEnteredValue);
    final isPaused =
        context.select<SudokuController, bool>((value) => value.isPaused);

    dev.log('${MediaQuery.sizeOf(context).height}');

    return InkWell(
      onTap: cell.isEditable
          ? () {
              final controller = context.read<SudokuController>();
              if (controller.focussedRow != cell.rowIndex ||
                  controller.focussedColumn != cell.colIndex) {
                controller.focussedCell(cell.rowIndex, cell.colIndex);
              } else {
                controller.focussedCell(-1, -1);
              }
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(
              50 +
                  (isFocussedBlock ? 75 : 0) +
                  (isFocussedRow && !isFocussedBlock ? 75 : 0) +
                  (isFocussedCol && !isFocussedBlock ? 75 : 0),
              r,
              g,
              b),
        ),
        child: SizedBox(
          width: cellSize,
          height: cellSize,
          child: Center(
            child: isPaused
                ? Text(_generateRandomGlyph())
                : cell.value != 0
                    ? Text(
                        cell.value.toString(),
                        style: TextStyle(
                          fontWeight: cell.isEditable
                              ? FontWeight.w500
                              : FontWeight.w800,
                          fontSize: lastEnteredValue == cell.value ? 22 : 18,
                          color: cell.isEditable
                              ? cell.isPlacedCorrectly
                                  ? Colors.black
                                  : Colors.red
                              : const Color(0xff454545),
                        ),
                      )
                    : cell.hasNotes
                        ? _NotesGridBuilder(notes: cell.notes)
                        : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  final List<int> _glyphUnicodeRanges = [
    0x13000, // Egyptian Hieroglyphs
    0x16800, // Bamum Supplement
    0x10300, // Old Italic
    0x16A0, // Runic
  ];

  String _generateRandomGlyph() {
    final random = Random();
    int randomRange =
        _glyphUnicodeRanges[random.nextInt(_glyphUnicodeRanges.length)];
    int randomOffset =
        random.nextInt(50); // Add a small random offset for variety

    return String.fromCharCode(randomRange + randomOffset);
  }

  double _getSize(Size screenSize) => switch (screenSize.width) {
        > 1200 => screenSize.width * 0.25,
        > 960 => screenSize.width * 0.35,
        > 840 => screenSize.width * 0.45,
        > 480 => screenSize.width * 0.75,
        _ => screenSize.width * 0.75,
      };
}

class _NotesGridBuilder extends StatelessWidget {
  const _NotesGridBuilder({required this.notes});

  final List<int> notes;

  @override
  Widget build(BuildContext context) {
    final cellSize = (MediaQuery.sizeOf(context).width - 32) / 9;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 1, 1, 0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        children: notes.indexed
            .map(
              (e) => Text(
                '${e.$2 != 0 ? e.$1 + 1 : ''}',
                style: TextStyle(
                  fontSize: (cellSize / 3) - 4,
                  color: const Color(0xff454545),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
