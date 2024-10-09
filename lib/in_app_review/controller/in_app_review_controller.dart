import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/ask_to_rate_sheet.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/pre_review_sheet.dart';
import 'package:sudoku/in_app_review/view/bottomsheets/share_feedback_sheet.dart';
import 'package:sudoku/services/shared_preference_service.dart';

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
      final latestAppReviewTime = await SharedPreferenceService.instance
          .get<String>(SharedPreferenceKey.LATEST_IN_APP_REVIEW_TIME.name);
      // Return if already shown recently
      if (latestAppReviewTime != null &&
          (DateTime.tryParse(latestAppReviewTime)
                      ?.difference(DateTime.now())
                      .inDays
                      .abs() ??
                  0) <
              45) {
        return;
      }

      if (!context.mounted) return;

      final userLikesTheApp = await showModalBottomSheet<bool>(
        context: context,
        builder: (context) => const PreReviewSheet(),
      );
      if (userLikesTheApp == true) {
        SharedPreferenceService.instance.set<String>(
            SharedPreferenceKey.LATEST_IN_APP_REVIEW_TIME.name,
            DateTime.now().toString());
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
        // If the user disliked the app we'll prompt him the next day
        SharedPreferenceService.instance.set<String>(
            SharedPreferenceKey.LATEST_IN_APP_REVIEW_TIME.name,
            DateTime.now().add(const Duration(days: -44)).toString());
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
