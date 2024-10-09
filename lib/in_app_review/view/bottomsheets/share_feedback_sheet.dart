import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/gen/assets.gen.dart';
import 'package:sudoku/in_app_review/controller/in_app_review_controller.dart';
import 'package:sudoku/services/shared_preference_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Let us know how we can make things better!'),
          const SizedBox(height: 16),
          shouldShowTextField()
              ? _buildTextfield(context)
              : Text.rich(TextSpan(
                  text:
                      'You\'ve recently shared your feedback, please wait or mail us at ',
                  children: [
                      TextSpan(
                        text: 'instantsudoku@gmail.com',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url =
                                'mailto:instantsudoku@gmail.com?subject=Sudoku Game Feedback&body=PLEASE ENTER HERE';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              launchUrl(Uri.parse(url));
                            }
                          },
                      )
                    ])),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }

  bool shouldShowTextField() {
    final latestFeedbackTime = SharedPreferenceService
        .instance.cache[SharedPreferenceKey.LATEST_FEEDBACK_TIME.name];

    if (latestFeedbackTime == null) return true;

    return DateTime.now()
            .difference(DateTime.parse(latestFeedbackTime as String))
            .inDays >
        45;
  }

  TextFormField _buildTextfield(BuildContext context) {
    return TextFormField(
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
                : const Color(0xff454545)),
      ),
      maxLengthEnforcement: MaxLengthEnforcement.none,
      style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
      decoration: InputDecoration(
        constraints: const BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 2, color: Color(0xff454545)),
        ),
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: false
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
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
                  SharedPreferenceService.instance.set(
                      SharedPreferenceKey.LATEST_FEEDBACK_TIME.name,
                      DateTime.now().toString());
                },
                icon: Assets.icons.send.image(height: 24),
              ),
        isDense: true,
      ),
    );
  }
}
