import 'package:flutter/material.dart';

class PreReviewSheet extends StatelessWidget {
  const PreReviewSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Do you like playing our Sudoku game?',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('NO'))),
                const SizedBox(width: 16),
                Expanded(
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('YES!')))
              ],
            ),
          )
        ],
      ),
    );
  }
}
