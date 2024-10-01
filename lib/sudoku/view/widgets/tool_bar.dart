import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/ad/service/ad_service.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/sudoku/view/controller/hint_type.dart';
import 'package:sudoku/sudoku/view/controller/sudoku_controller.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              final controller = context.read<SudokuController>();
              if (!controller.hasFocussedCell) return;
              controller.updateCell(0);
            },
            icon: Assets.icons.backspace.image(),
          ),
          const _NoteModeToggleButton(),
          const _HintButton(),
          IconButton(
            onPressed: () {
              context.read<SudokuController>().undo();
            },
            icon: Assets.icons.undo.image(),
          ),
        ],
      ),
    );
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final hintTypeCounter =
            context.read<SudokuController>().hintTypeCounter;

        final hintType = await showModalBottomSheet<HintType?>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: HintType.values
                  .map(
                    (e) => _HintTypeButton(
                        hintTypeCounter: hintTypeCounter, type: e),
                  )
                  .toList(),
            ),
          ),
        );

        if (context.mounted && hintType != null) {
          context.read<SudokuController>().takeHint(hintType);
        }
      },
      icon: Assets.icons.lightBulb.image(),
    );
  }
}

class _NoteModeToggleButton extends StatelessWidget {
  const _NoteModeToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isNoteModeOn =
        context.select<SudokuController, bool>((value) => value.noteModeOn);
    return IconButton(
      onPressed: () {
        final val = context.read<SudokuController>().noteModeOn;
        context.read<SudokuController>().noteModeOn = !val;
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Assets.icons.edit.image(),
          Positioned(
            bottom: 2,
            left: 22,
            child: Text(
              isNoteModeOn ? 'ON' : 'OFF',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintTypeButton extends StatefulWidget {
  const _HintTypeButton({
    super.key,
    required this.hintTypeCounter,
    required this.type,
  });

  final Map<HintType, int> hintTypeCounter;
  final HintType type;

  @override
  State<_HintTypeButton> createState() => __HintTypeButtonState();
}

class __HintTypeButtonState extends State<_HintTypeButton> {
  late bool isLoadingAd;
  @override
  void initState() {
    isLoadingAd = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        if (widget.hintTypeCounter[widget.type]! > 0) {
          Navigator.pop(context, widget.type);
        } else {
          setState(() {
            isLoadingAd = true;
          });
          final adLoadSuccess = await AdService.displayRewardedInterstitialAd(
            (ad) {
              ad.show(
                onUserEarnedReward: (ad, reward) {
                  Navigator.pop(context, widget.type);
                },
              );
            },
          );
          setState(() {
            isLoadingAd = false;
          });
          if (adLoadSuccess) {}
        }
      },
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(switch (widget.type) {
            HintType.cell => 'Reveal a single cell',
            HintType.row => 'Reveal a single row',
            HintType.block => 'Reveal a single block',
          }),
          const SizedBox(width: 4),
          isLoadingAd
              ? SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 0.75,
                  ))
              : Badge(
                  label: Text(
                    widget.hintTypeCounter[widget.type]! > 0
                        ? widget.hintTypeCounter[widget.type].toString()
                        : 'AD',
                  ),
                )
        ],
      ),
    );
  }
}
