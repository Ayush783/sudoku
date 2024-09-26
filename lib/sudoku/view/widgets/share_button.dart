import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final board = context.read<SudokuController>().board;
          final boardAsString = board!.cellMatrix
              .map(
                (e) => e.map(
                  (e) => e.value,
                ),
              )
              .map(
                (element) => element.join(''),
              )
              .join('');
          final code = utf8.encode(boardAsString);
          log(base64Url.encode(code));
        },
        icon: const Icon(Icons.share_outlined));
  }
}

// [5, 3, 0, 4, 1, 0, 6, 7, 9]
// [0, 0, 0, 0, 0, 7, 0, 5, 0]
// [7, 0, 9, 3, 0, 0, 4, 0, 1]
// [0, 9, 0, 0, 0, 6, 0, 3, 0]
// [6, 8, 0, 1, 5, 0, 9, 4, 0]
// [3, 0, 0, 0, 0, 4, 0, 6, 7]
// [0, 0, 0, 0, 0, 0, 0, 0, 4]
// [1, 2, 3, 0, 4, 0, 5, 8, 6]
// [9, 0, 4, 5, 6, 8, 0, 0, 3]

// 530410679
// 000007050
// 709300401
// 090006030
// 680150940
// 300004067
// 000000004
// 123040586
// 904568003

// 530410679000007050709300401090006030680150940300004067000000004123040586904568003