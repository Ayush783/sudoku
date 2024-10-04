import 'package:flutter/material.dart';
import 'package:sudoku/web-app/view/sudoku_web_landing_page.dart';

class SudokuWebApp extends StatelessWidget {
  const SudokuWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SudokuWebLandingPage(),
    );
  }
}
