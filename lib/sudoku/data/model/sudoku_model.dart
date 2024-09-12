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
                          )
                        : SudokuCellModel(
                            value: 0,
                            isEditable: true,
                            colIndex: e.$1,
                            rowIndex: row.$1,
                          ),
                  )
                  .toList(),
            )
            .toList();

  SudokuBoardModel update(int value, int rowIndex, int colIndex) {
    cellMatrix[rowIndex][colIndex] =
        cellMatrix[rowIndex][colIndex].copyWith(value);
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
  SudokuCellModel({
    required this.value,
    required this.rowIndex,
    required this.colIndex,
    required this.isEditable,
  });

  SudokuCellModel copyWith(
    int? value,
  ) =>
      SudokuCellModel(
        value: value ?? this.value,
        isEditable: isEditable,
        rowIndex: rowIndex,
        colIndex: colIndex,
      );
}
