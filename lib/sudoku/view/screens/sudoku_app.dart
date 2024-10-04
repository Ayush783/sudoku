import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/app_links/service/app_links_service.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/data/model/sudoku_model.dart';
import 'package:sudoku/sudoku/view/screens/app_theme.dart';

import 'package:sudoku/sudoku/view/widgets/sudoku_app_bar.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board.dart';

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key});

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  final SudokuController _sudokuController = SudokuController();
  @override
  void initState() {
    AppLinksService.getAppLaunchedArticleId().then(
      (boardLink) {
        if (boardLink != null) {
          _sudokuController
              .generateSudokuFromID(boardLink.path.replaceFirst('/', ''));
        } else {
          _sudokuController.generateSudoku();
        }
      },
    );
    AppLinksService.onLink?.listen(
      (boardLink) {
        if (boardLink != null) {
          _sudokuController
              .generateSudokuFromID(boardLink.path.replaceFirst('/', ''));
        }
      },
    );
    super.initState();
  }

  SudokuBoardModel? model;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SudokuController>.value(
      value: _sudokuController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          appBar: SudokuAppBar(),
          body: SudokuBoard(),
        ),
      ),
    );
  }
}
