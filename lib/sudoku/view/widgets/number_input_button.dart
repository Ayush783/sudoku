import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class NumberInputButton extends StatefulWidget {
  const NumberInputButton({
    super.key,
    required this.value,
  });

  final int value;

  @override
  State<NumberInputButton> createState() => _NumberInputButtonState();
}

class _NumberInputButtonState extends State<NumberInputButton> {
  late int r, g, b;

  @override
  void initState() {
    r = Random().nextInt(235) + 20;
    g = Random().nextInt(235) + 20;
    b = Random().nextInt(235) + 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = (MediaQuery.sizeOf(context).width - 64) / 5;
    return InkWell(
      onTap: () {
        final controller = context.read<SudokuController>();

        if (!controller.hasFocussedCell) return;

        controller.updateCell(widget.value);
      },
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            // color: Color.fromARGB(100, r, g, b),
            color: Color(0xfff1f1f1),
            boxShadow: [
              // BoxShadow(
              //   blurRadius: 0,
              //   offset: Offset(1, 1),
              //   color: Colors.black.withOpacity(0.1),
              // )
            ]),
        child: Center(
          child: Text(
            '${widget.value}',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
