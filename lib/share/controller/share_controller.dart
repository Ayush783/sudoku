import 'dart:convert';
import 'dart:developer';

import 'package:share_plus/share_plus.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';

class ShareController {
  static void shareIncompleteBoard(SudokuBoardModel board) {
    final uniqueId = _buildId(board);
    Share.share(
        'Hey! I\'m facing trouble solving this Sudoku puzzle, Can you help me out?\nhttps://aayushsharma.me/$uniqueId');
  }

  static void shareCompleteBoard(SudokuBoardModel board, String timeElapsed) {
    final uniqueId = _buildId(board);
    Share.share(
        'Hey! Icompleted this Sudoku puzzle in $timeElapsed, Can you beat me?\nhttps://aayushsharma.me/$uniqueId');
  }

  static void shareUri(Uri uri) => Share.shareUri(uri);

  static String _buildId(SudokuBoardModel board) {
    final boardAsString = board.cellMatrix
        .map(
          (e) => e.map(
            (e) => e.isEditable ? 0 : e.value,
          ),
        )
        .map(
          (element) => element.join(''),
        )
        .join('');
    final code = utf8.encode(boardAsString);
    final uniqueId = base64Url.encode(code);
    log(uniqueId);
    return uniqueId;
  }
}
