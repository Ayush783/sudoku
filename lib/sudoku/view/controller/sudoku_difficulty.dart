enum SudokuDifficulty {
  easy,
  medium,
  hard;

  int get value => switch (this) {
        easy => 40,
        medium => 48,
        hard => 55,
      };
}
