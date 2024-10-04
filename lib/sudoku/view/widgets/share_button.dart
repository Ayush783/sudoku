import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/analytics/analytics.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/share/controller/share_controller.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final boardID = context.read<SudokuController>().board!.id;
          Analytics.instance
              .logEvent(AnalyticEvent.SHARE, properties: {'boardID': boardID});
          ShareController.shareIncompleteBoard(boardID);
        },
        icon: Assets.icons.whatsapp.image(height: 24));
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

// NjAwMDIxMzc0NTIxNzM0OTAwNzAwNjA4MDAwNDUwMDAwNjEwMTYyMDUzNzg5MDAwMTAyMDAwMDE1OTA3MDA2MDAwMjA2MDA1MDAwMDA1NDA3