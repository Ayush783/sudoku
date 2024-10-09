import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/ask_to_rate_sheet.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/pre_review_sheet.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/share_feedback_sheet.dart';

class InAppReviewController {
  static final inAppReviewInstance = InAppReview.instance;
  static const _logName = "inAppReviewController";

  /// Must be triggered when a game is completed successfuly
  /// Gets the last shown date for in app review, if it was shown 30 days before then show a dialog box.
  /// This dialog box asks the user if he likes the app or not.
  /// If user does not like the app then show a feedback field.
  /// If user likes the app then show the in app review dialog box.
  static void askForReview(BuildContext context) async {
    try {
      final userLikesTheApp = await showModalBottomSheet<bool>(
        context: context,
        builder: (context) => const PreReviewSheet(),
      );
      if (userLikesTheApp == true) {
        if (await inAppReviewInstance.isAvailable()) {
          inAppReviewInstance.requestReview();
        } else {
          if (context.mounted) {
            final shouldRedirectToPlaystore = await showModalBottomSheet<bool>(
              context: context,
              builder: (context) => const AskToRateSheet(),
            );

            if (shouldRedirectToPlaystore ?? false) {
              inAppReviewInstance.openStoreListing();
            }
          }
        }
      } else if (userLikesTheApp == false) {
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const ShareFeedbackSheet(),
          );
        }
      }
    } catch (e) {
      log(e.toString(), name: _logName);
    }
  }

  static Future<bool> shareFeedback(String feedback) async {
    try {
      return true;
    } catch (e) {
      log('$e', name: _logName);
      return false;
    }
  }
}
