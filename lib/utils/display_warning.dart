import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';

class WarningDisplay {
  static void showWarningToast(String? message, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // handle null or empty message
    if (message == null || message.isEmpty == true) {
      return;
    }
    // if message is not null or empty, show snackbar
    final snackBar = SnackBar(
      backgroundColor: colorScheme.inversePrimary,
      content: CustomAlignText(
          text: message,
          alignment: Alignment.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: colorScheme.onInverseSurface, fontWeight: FontWeight.w500)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
