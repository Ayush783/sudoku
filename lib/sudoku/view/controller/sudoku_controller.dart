import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_difficulty.dart';

class SudokuController extends ChangeNotifier {
  SudokuBoardModel? _board;
  SudokuBoardModel? get board => _board;

  final List<SudokuBoardModel> _boardStates = [];

  bool get hasProgress => _boardStates.isNotEmpty;

  int _focussedRow = -1;
  int get focussedRow => _focussedRow;

  int _focussedColumn = -1;
  int get focussedColumn => _focussedColumn;

  bool get hasFocussedCell => _focussedColumn != -1 && _focussedRow != -1;

  int _lastEnteredValue = 0;
  int get lastEnteredValue => _lastEnteredValue;

  void focussedCell(int row, int col) {
    _focussedRow = row;
    _focussedColumn = col;
    _lastEnteredValue = 0;
    notifyListeners();
  }

  SudokuDifficulty _currentDifficulty = SudokuDifficulty.easy;
  SudokuDifficulty get currentDifficulty => _currentDifficulty;

  set currentDifficulty(SudokuDifficulty val) {
    _currentDifficulty = val;
    resetAndGenerateBoard();
    notifyListeners();
  }

  void resetAndGenerateBoard() {
    _boardStates.clear();
    _focussedColumn = -1;
    _focussedRow = -1;
    _lastEnteredValue = 0;
    generateSudoku(difficulty: _currentDifficulty);
  }

  Timer? _gameTimer;
  Duration _timeElapsed = Duration.zero;
  Duration get timeElapsed => _timeElapsed;

  void initiateTimer() {
    _gameTimer?.cancel();
    _timeElapsed = Duration.zero;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeElapsed = _timeElapsed + const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void generateSudoku({SudokuDifficulty difficulty = SudokuDifficulty.easy}) {
    List<List<int>> board = List.generate(9, (_) => List.generate(9, (_) => 0));
    _solveSudoku(board);
    _removeNumbers(board, difficulty.value);
    _board = SudokuBoardModel.fromData(board);
    initiateTimer();
    notifyListeners();
  }

  void updateCell(int value) {
    if (_board!.cellMatrix[_focussedRow][_focussedColumn].value == value) {
      return;
    }

    _boardStates.add(_board!.copyWith());
    _lastEnteredValue = value == 10 ? 0 : value;
    _board =
        _board?.update(value == 10 ? 0 : value, _focussedRow, _focussedColumn);
    notifyListeners();
  }

  void undo() {
    if (_boardStates.isEmpty) return;
    _lastEnteredValue = 0;
    final prevState = _boardStates.removeLast();
    _board = prevState;
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  bool _isSafe(List<List<int>> board, int row, int col, int num) {
    // Check if the number is not already placed in the current row or column
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num || board[x][col] == num) {
        return false;
      }
    }

    // Check if the number is not already placed in the 3x3 sub-grid
    int startRow = 3 * (row ~/ 3), startCol = 3 * (col ~/ 3);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool _solveSudoku(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isSafe(board, row, col, num)) {
              board[row][col] = num;
              if (_solveSudoku(board)) {
                return true;
              }
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  void _removeNumbers(List<List<int>> board, int level) {
    Random random = Random();
    for (int i = 0; i < level; i++) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      while (board[row][col] == 0) {
        row = random.nextInt(9);
        col = random.nextInt(9);
      }
      board[row][col] = 0;
    }
  }
}
