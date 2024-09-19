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

  SudokuBoardModel update(int value, int rowIndex, int colIndex,
      {bool isNote = false}) {
    cellMatrix[rowIndex][colIndex] =
        cellMatrix[rowIndex][colIndex].copyWith(value, isNote: isNote);

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
}

class SudokuCellModel {
  final int value;
  final int rowIndex;
  final int colIndex;
  final bool isEditable;
  final List<int> notes;

  bool get hasNotes => notes.any((element) => element == 1);

  SudokuCellModel({
    required this.value,
    required this.rowIndex,
    required this.colIndex,
    required this.isEditable,
    this.notes = const [],
  });

  SudokuCellModel copyWith(
    int? value, {
    bool isNote = false,
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
    );
  }
}
