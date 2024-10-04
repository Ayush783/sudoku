import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:sudoku/analytics/analytics.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/controller/hint_type.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_difficulty.dart';

class SudokuController extends ChangeNotifier {
  static const _logName = 'SudokuController';
  SudokuBoardModel? _board;
  SudokuBoardModel? _solvedBoard;
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

  bool _isBoardCompleted = false;
  bool get isBoardCompleted => _isBoardCompleted;

  void resetAndGenerateBoard() {
    _boardStates.clear();
    _focussedColumn = -1;
    _focussedRow = -1;
    _lastEnteredValue = 0;
    _isBoardCompleted = false;
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
    final randomBoard = _generateRandomBoard();
    _solvedBoard = SudokuBoardModel.fromData(randomBoard);
    _removeNumbers(randomBoard, difficulty.value);
    _board = SudokuBoardModel.fromData(randomBoard);
    startTimer(reset: true);
    _hintTypeCounter = {HintType.cell: 3, HintType.row: 2, HintType.block: 1};

    Analytics.instance.logEvent(AnalyticEvent.NEW_GAME, properties: {
      'boardID': _board!.id,
    });

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

    if (_board!.isFilled) {
      verifyBoard();
      if (_board!.isCompleted) {
        _gameCompleted();
      }
    }

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

  void verifyBoard() {
    for (var row in _board!.cellMatrix) {
      for (var cell in row) {
        if (cell.value == 0 || !cell.isEditable) continue;

        if (!_isSafe(cell.rowIndex, cell.colIndex)) {
          _board = _board!.update(cell.value, cell.rowIndex, cell.colIndex,
              isPlacedCorrectly: false);
        } else {
          _board = _board!.update(cell.value, cell.rowIndex, cell.colIndex,
              isPlacedCorrectly: true);
        }
      }
    }

    notifyListeners();
  }

  void _solveFor(int row, int col) {
    _board = _board!.update(_solvedBoard!.cellMatrix[row][col].value, row, col);
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

  bool _isSafe(int row, int col) {
    final board =
        _board!.cellMatrix.map((e) => e.map((e) => e.value).toList()).toList();
    final num = board[row][col];
    // Check if the number is not already placed in the current row or column
    for (int x = 0; x < 9; x++) {
      if ((board[row][x] == num && x != col) ||
          (board[x][col] == num && x != row)) {
        return false;
      }
    }

    // Check if the number is not already placed in the 3x3 sub-board
    int startRow = 3 * (row ~/ 3), startCol = 3 * (col ~/ 3);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num &&
            i + startRow != row &&
            j + startCol != col) {
          return false;
        }
      }
    }

    return true;
  }

  List<List<int>> _generateRandomBoard() {
    List<int> baseRange = [0, 1, 2];

    List<int> rows = [];
    for (var g in _shuffleList(baseRange)) {
      for (var r in _shuffleList(baseRange)) {
        rows.add(g * 3 + r);
      }
    }

    List<int> cols = [];
    for (var g in _shuffleList(baseRange)) {
      for (var c in _shuffleList(baseRange)) {
        cols.add(g * 3 + c);
      }
    }

    List<int> nums = _shuffleList([1, 2, 3, 4, 5, 6, 7, 8, 9]);

    List<List<int>> board = [];

    for (var r in rows) {
      List<int> thisRow = [];
      for (var c in cols) {
        thisRow.add(nums[_pattern(r, c)]);
      }
      board.add(thisRow);
    }

    return board;
  }

  int _pattern(int r, int c) {
    return (3 * (r % 3) + r ~/ 3 + c) % 9;
  }

  List<int> _shuffleList(List<int> list) {
    list.shuffle();
    return List.from(list);
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

  void _gameCompleted() {
    _isBoardCompleted = true;
    Analytics.instance.logEvent(AnalyticEvent.COMPLETED, properties: {
      'boardID': _board!.id,
    });
    _gameTimer?.cancel();
  }

  void generateSudokuFromID(String id) {
    final boardFromID = _retrieveBoardFromID(id);
    _solvedBoard = SudokuBoardModel.fromData(boardFromID);
    _board = SudokuBoardModel.fromData(boardFromID);
    startTimer(reset: true);
    _hintTypeCounter = {HintType.cell: 3, HintType.row: 2, HintType.block: 1};

    Analytics.instance.logEvent(AnalyticEvent.NEW_GAME, properties: {
      'boardID': _board!.id,
    });

    notifyListeners();
  }

  List<List<int>> _retrieveBoardFromID(String id) {
    final code = base64Url.decode(id);
    final boardData = utf8.decode(code);
    List<List<int>> retrievedCellMatrix = [];

    for (int i = 0; i < 9; i++) {
      retrievedCellMatrix.add([]);
      for (int j = 0; j < 9; j++) {
        retrievedCellMatrix[i].add(
          int.parse(boardData[i * 9 + j]),
        );
      }
    }

    return retrievedCellMatrix;
  }
}
