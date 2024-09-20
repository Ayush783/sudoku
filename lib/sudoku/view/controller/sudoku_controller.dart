import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/hint_type.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_difficulty.dart';

class SudokuController extends ChangeNotifier {
  static const _logName = 'SudokuController';
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

  bool _noteModeOn = false;
  bool get noteModeOn => _noteModeOn;
  set noteModeOn(bool val) {
    _noteModeOn = val;
    notifyListeners();
  }

  late Map<HintType, int> _hintTypeCounter;
  Map<HintType, int> get hintTypeCounter => _hintTypeCounter;

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

  void startTimer({bool reset = false}) {
    if (reset) _timeElapsed = Duration.zero;

    if (_isPaused) {
      _isPaused = false;
      notifyListeners();
    }

    _gameTimer?.cancel();
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
    startTimer(reset: true);
    _hintTypeCounter = {HintType.cell: 3, HintType.row: 2, HintType.block: 1};
    notifyListeners();
  }

  void updateCell(int value) {
    if (!_noteModeOn &&
        _board!.cellMatrix[_focussedRow][_focussedColumn].value == value) {
      return;
    }

    _boardStates.add(_board!.copyWith());

    _lastEnteredValue = _noteModeOn
        ? 0
        : value == 10
            ? 0
            : value;

    _board = _board?.update(
        value == 10 ? 0 : value, _focussedRow, _focussedColumn,
        isNote: _noteModeOn);
    notifyListeners();
  }

  void undo() {
    if (_boardStates.isEmpty) return;
    _lastEnteredValue = 0;
    final prevState = _boardStates.removeLast();
    _board = prevState;
    notifyListeners();
  }

  void takeHint(HintType type) {
    _hintTypeCounter[type] = _hintTypeCounter[type]! - 1;
    switch (type) {
      case HintType.cell:
        _fillSingleCell();
        break;
      case HintType.row:
        _fillRandomIncompleteRow();
        break;
      case HintType.block:
        _fillRandomIncompleteBlock();
        break;
    }

    _boardStates.clear();
    _lastEnteredValue = 0;
    _focussedColumn = -1;
    _focussedRow = -1;
    _noteModeOn = false;

    notifyListeners();
  }

  void _solveFor(int row, int col) {
    for (int i = 1; i <= 9; i++) {
      final isSafe = _isSafe(
          _board!.cellMatrix
              .map((e) => e.map((e) => e.value).toList())
              .toList(),
          row,
          col,
          i);
      if (isSafe) {
        _board = _board!.update(i, row, col);
        break;
      }
    }
  }

  // Reveal a single random cell
  void _fillSingleCell() {
    List<List<int>> emptyCells = [];

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board!.cellMatrix[i][j].value == 0) {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      var randomCell = emptyCells[Random().nextInt(emptyCells.length)];
      int row = randomCell[0];
      int col = randomCell[1];
      _solveFor(row, col);
    } else {
      dev.log("No empty cells to reveal", name: _logName);
    }
  }

// Reveal a random incomplete row
  void _fillRandomIncompleteRow() {
    List<int> incompleteRows = [];

    for (int i = 0; i < 9; i++) {
      final currRowValues = _board!.cellMatrix[i].map((e) => e.value);
      if (currRowValues.contains(0)) {
        incompleteRows.add(i);
      }
    }

    if (incompleteRows.isNotEmpty) {
      int randomRow = incompleteRows[Random().nextInt(incompleteRows.length)];
      for (int j = 0; j < 9; j++) {
        if (_board!.cellMatrix[randomRow][j].value == 0) {
          _solveFor(randomRow, j);
        }
      }
    } else {
      dev.log("No incomplete rows to reveal.", name: _logName);
    }
  }

// Reveal a random incomplete 3x3 block
  void _fillRandomIncompleteBlock() {
    List<List<int>> incompleteBlocks = [];

    for (int blockRow = 0; blockRow < 3; blockRow++) {
      for (int blockCol = 0; blockCol < 3; blockCol++) {
        bool hasEmptyCell = false;
        for (int i = blockRow * 3; i < (blockRow + 1) * 3; i++) {
          for (int j = blockCol * 3; j < (blockCol + 1) * 3; j++) {
            if (_board!.cellMatrix[i][j].value == 0) {
              hasEmptyCell = true;
            }
          }
        }
        if (hasEmptyCell) {
          incompleteBlocks.add([blockRow, blockCol]);
        }
      }
    }

    if (incompleteBlocks.isNotEmpty) {
      var randomBlock =
          incompleteBlocks[Random().nextInt(incompleteBlocks.length)];
      int blockRow = randomBlock[0];
      int blockCol = randomBlock[1];

      for (int i = blockRow * 3; i < (blockRow + 1) * 3; i++) {
        for (int j = blockCol * 3; j < (blockCol + 1) * 3; j++) {
          if (_board!.cellMatrix[i][j].value == 0) {
            _solveFor(i, j);
          }
        }
      }
    } else {
      dev.log("No incomplete blocks to reveal.", name: _logName);
    }
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

    // Check if the number is not already placed in the 3x3 sub-board
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

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  void pauseTimer() {
    _gameTimer?.cancel();
    _isPaused = true;
    notifyListeners();
  }
}
