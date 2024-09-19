import 'dart:math';

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
    final cellSize = (MediaQuery.sizeOf(context).width - 32) / 9;
    final lastEnteredValue = context
        .select<SudokuController, int>((value) => value.lastEnteredValue);
    final isPaused =
        context.select<SudokuController, bool>((value) => value.isPaused);

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
      child: ColoredBox(
        color: Color.fromARGB(
            50 + (isFocussedRow ? 75 : 0) + (isFocussedCol ? 75 : 0), r, g, b),
        child: SizedBox(
          width: cellSize,
          height: cellSize,
          child: Center(
            child: isPaused
                ? Text(_generateRandomGlyph())
                : Text(
                    cell.value != 0 ? cell.value.toString() : '',
                    style: TextStyle(
                      fontWeight:
                          cell.isEditable ? FontWeight.w500 : FontWeight.w800,
                      fontSize: lastEnteredValue == cell.value ? 22 : 18,
                      color: cell.isEditable
                          ? Colors.black
                          : const Color(0xff454545),
                    ),
                  ),
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
}
