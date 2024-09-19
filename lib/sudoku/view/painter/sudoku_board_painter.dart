import 'package:flutter/material.dart';

class SudokuBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Grid dimensions
    double cellSize = size.width / 9;

    // Draw outer border
    final outerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw outer square
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.width), outerPaint);

    // Draw the 9x9 grid lines
    for (int i = 0; i <= 9; i++) {
      double position = i * cellSize;

      // Horizontal lines
      canvas.drawLine(Offset(0, position), Offset(size.width, position),
          i % 3 == 0 ? outerPaint : paint);

      // Vertical lines
      canvas.drawLine(Offset(position, 0), Offset(position, size.width),
          i % 3 == 0 ? outerPaint : paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
