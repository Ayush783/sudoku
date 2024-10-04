import 'dart:convert';
import 'dart:developer';

class SudokuBoardModel {
  final List<List<SudokuCellModel>> cellMatrix;
  SudokuBoardModel({required this.cellMatrix});

  SudokuBoardModel.fromData(List<List<int>> board)
      : cellMatrix = board.indexed
            .map(
              (row) => row.$2.indexed
                  .map(
                    (e) => e.$2 != 0
                        ? SudokuCellModel(
                            value: e.$2,
                            isEditable: false,
                            isPlacedCorrectly: true,
                            colIndex: e.$1,
                            rowIndex: row.$1,
                            notes: List.filled(9, 0, growable: false),
                          )
                        : SudokuCellModel(
                            value: 0,
                            isEditable: true,
                            colIndex: e.$1,
                            rowIndex: row.$1,
                            notes: List.filled(9, 0, growable: false),
                          ),
                  )
                  .toList(),
            )
            .toList();

  /// Returns true if every cell is filled
  bool get isFilled => cellMatrix
      .every((element) => element.every((element) => element.value != 0));

  /// Returns true if every cell is filled and placed correctly
  bool get isCompleted => cellMatrix.every((element) => element
      .every((element) => element.value != 0 && element.isPlacedCorrectly));

  SudokuBoardModel update(int value, int rowIndex, int colIndex,
      {bool isNote = false, bool? isPlacedCorrectly}) {
    cellMatrix[rowIndex][colIndex] = cellMatrix[rowIndex][colIndex]
        .copyWith(value, isNote: isNote, isPlacedCorrectly: isPlacedCorrectly);

    return SudokuBoardModel(cellMatrix: List.from(cellMatrix));
  }

  SudokuBoardModel copyWith({List<List<SudokuCellModel>>? cellMatrix}) =>
      SudokuBoardModel(
          cellMatrix: cellMatrix ??
              this
                  .cellMatrix
                  .map(
                    (row) => row
                        .map(
                          (e) => e.copyWith(e.value),
                        )
                        .toList(),
                  )
                  .toList());

  // factory SudokuBoardModel.fromID(String id) {
  //   final code = base64Url.decode(id);
  //   final boardData = utf8.decode(code);
  //   List<List<int>> retrievedCellMatrix = [];

  //   for (int i = 0; i < 9; i++) {
  //     retrievedCellMatrix.add([]);
  //     for (int j = 0; j < 9; j++) {
  //       retrievedCellMatrix[i].add(
  //         int.parse(boardData[i * 9 + j]),
  //       );
  //     }
  //   }

  //   return SudokuBoardModel.fromData(retrievedCellMatrix);
  // }

  String get id {
    final boardAsString = cellMatrix
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

class SudokuCellModel {
  final int value;
  final int rowIndex;
  final int colIndex;
  final bool isEditable;
  final List<int> notes;
  final bool isPlacedCorrectly;

  bool get hasNotes => notes.any((element) => element == 1);

  SudokuCellModel({
    required this.value,
    required this.rowIndex,
    required this.colIndex,
    required this.isEditable,
    this.notes = const [],
    this.isPlacedCorrectly = true,
  });

  SudokuCellModel copyWith(
    int? value, {
    bool isNote = false,
    bool? isPlacedCorrectly,
  }) {
    if (isNote) {
      notes[value! - 1] = notes[value - 1] ^ 1;
    }

    return SudokuCellModel(
      value: isNote ? 0 : value ?? this.value,
      isEditable: isEditable,
      rowIndex: rowIndex,
      colIndex: colIndex,
      notes: [...notes],
      isPlacedCorrectly: isPlacedCorrectly ?? this.isPlacedCorrectly,
    );
  }
}
