import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';

class SuccessDisplay {
  static void showSuccessToast(String? message, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // handle null or empty message
    if (message == null || message.isEmpty == true) {
      return;
    }
    // if message is not null or empty, show snackbar
    final snackBar = SnackBar(
      backgroundColor: colorScheme.tertiary,
      content: Row(
        children: [
          Icon(Icons.check_circle, color: colorScheme.success),
          const SizedBox(width: 10),
          CustomAlignText(
              text: message,
              alignment: Alignment.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: colorScheme.success, fontWeight: FontWeight.w500))
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
