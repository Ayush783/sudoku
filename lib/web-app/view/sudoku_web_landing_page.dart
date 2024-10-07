import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';
import 'package:sudoku/sudoku/view/painter/sudoku_board_painter.dart';
import 'package:sudoku/sudoku/view/widgets/sudoku_board_cell.dart';

class SudokuWebLandingPage extends StatefulWidget {
  const SudokuWebLandingPage({super.key});

  @override
  State<SudokuWebLandingPage> createState() => _SudokuWebLandingPageState();
}

class _SudokuWebLandingPageState extends State<SudokuWebLandingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<SudokuController>().playAutomatically();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<SudokuController>().board!;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Instant Sudoku',
                style: TextStyle(fontSize: 32, height: 0.6),
              ),
              const Text(
                'now available on Android',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 24),
              IgnorePointer(
                ignoring: true,
                child: SizedBox(
                  height: _getSize(size),
                  width: _getSize(size),
                  child: CustomPaint(
                    painter: SudokuBoardPainter(),
                    child: Column(
                      children: board.cellMatrix
                          .map(
                            (row) => Row(
                              children: row
                                  .map((e) => SudokuBoardCell(cell: e))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              IconButton.filled(
                  onPressed: () {},
                  color: Color.fromARGB(50, Random().nextInt(150) + 55,
                      Random().nextInt(150) + 55, Random().nextInt(150) + 55),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Get it on Google Play'),
                      Assets.icons.playstore.image(height: 24),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  double _getSize(Size screenSize) => switch (screenSize.width) {
        > 1200 => screenSize.width * 0.25,
        > 960 => screenSize.width * 0.35,
        > 840 => screenSize.width * 0.45,
        > 480 => screenSize.width * 0.75,
        _ => screenSize.width * 0.75,
      };
}
