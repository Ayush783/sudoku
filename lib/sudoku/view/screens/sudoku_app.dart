import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/screens/app_theme.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board.dart';

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key});

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  SudokuBoardModel? model;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sudoku'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => SudokuController()..generateSudoku(),
          child: SudokuBoard(),
        ),
      ),
    );
  }
}
