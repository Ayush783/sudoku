import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/in_app_review/controller/in_app_review_controller.dart';

class ShareFeedbackSheet extends StatefulWidget {
  const ShareFeedbackSheet({super.key});

  @override
  State<ShareFeedbackSheet> createState() => _ShareFeedbackSheetState();
}

class _ShareFeedbackSheetState extends State<ShareFeedbackSheet> {
  double bottomInset = 0;
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ShareFeedbackSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Let us know how we can make things better!'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 250,
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: currentLength > (maxLength ?? 0)
                      ? Colors.red
                      : Color(0xff454545)),
            ),
            maxLengthEnforcement: MaxLengthEnforcement.none,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            decoration: InputDecoration(
              constraints: const BoxConstraints(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(width: 2, color: Color(0xff454545)),
              ),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: false
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                    )
                  : IconButton(
                      onPressed: () {
                        // TODO: SEND FEEDBACK, store the date of feedback. If user wants to share another feedback ask him to mail at primary mail
                        final feedback = _controller.text;
                        InAppReviewController.shareFeedback(feedback);
                        _controller.clear();
                        Navigator.pop(context);
                      },
                      icon: Assets.icons.send.image(height: 24),
                    ),
              isDense: true,
            ),
          ),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }
}
