import 'package:share_plus/share_plus.dart';

class ShareController {
  static void shareIncompleteBoard(String boardID) {
    Share.share(
        'Hey! I\'m facing trouble solving this Sudoku puzzle, Can you help me out?\nhttps://aayushsharma.me/$boardID');
  }

  static void shareCompleteBoard(String boardID, String timeElapsed) {
    Share.share(
        'Hey! Icompleted this Sudoku puzzle in $timeElapsed, Can you beat me?\nhttps://aayushsharma.me/$boardID');
  }

  static void shareUri(Uri uri) => Share.shareUri(uri);
}
