import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/screens/app_theme.dart';
import 'package:sudoku/web-app/view/sudoku_web_landing_page.dart';

class SudokuWebApp extends StatelessWidget {
  const SudokuWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SudokuController()..generateSudoku(),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SudokuWebLandingPage(),
      ),
    );
  }
}
