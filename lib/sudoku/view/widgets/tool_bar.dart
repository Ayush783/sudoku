import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/ad/service/ad_service.dart';
import 'package:sudoku/analytics/analytics.dart';
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
            icon: Assets.icons.backspace.image(height: 40),
          ),
          const _NoteModeToggleButton(),
          const _HintButton(),
          IconButton(
            onPressed: () {
              Analytics.instance.logEvent(AnalyticEvent.UNDO);
              context.read<SudokuController>().undo();
            },
            icon: Assets.icons.undo.image(height: 40),
          ),
        ],
      ),
    );
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton();

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
      icon: Assets.icons.lightBulb.image(height: 40),
    );
  }
}

class _NoteModeToggleButton extends StatelessWidget {
  const _NoteModeToggleButton();

  @override
  Widget build(BuildContext context) {
    final isNoteModeOn =
        context.select<SudokuController, bool>((value) => value.noteModeOn);
    return IconButton(
      onPressed: () {
        final val = context.read<SudokuController>().noteModeOn;
        context.read<SudokuController>().noteModeOn = !val;
        if (val) {
          Analytics.instance.logEvent(AnalyticEvent.USING_NOTES);
        }
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Assets.icons.edit.image(height: 40),
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
          Analytics.instance.logEvent(AnalyticEvent.HINT_TAKEN, properties: {
            'hintType': widget.type.name,
          });
          Navigator.pop(context, widget.type);
        } else {
          setState(() {
            isLoadingAd = true;
          });
          final adLoadSuccess = await AdService.displayRewardedInterstitialAd(
            (ad) {
              ad.show(
                onUserEarnedReward: (ad, reward) {
                  Analytics.instance
                      .logEvent(AnalyticEvent.HINT_TAKEN, properties: {
                    'hintType': widget.type.name,
                  });
                  Navigator.pop(context, widget.type);
                },
              );
            },
          );
          setState(() {
            isLoadingAd = false;
          });
          if (!adLoadSuccess && context.mounted) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              const SnackBar(
                content: Text('Could\'nt load Ads at the moment'),
              ),
            );
          }
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
              ? const SizedBox(
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
