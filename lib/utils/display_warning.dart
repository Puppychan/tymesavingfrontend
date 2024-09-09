import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class WarningDisplay {
  static void showWarningToast(String? message, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? colorScheme.inversePrimary : colorScheme.warning;
    // handle null or empty message
    if (message == null || message.isEmpty == true) {
      return;
    }
    // if message is not null or empty, show snackbar
    final snackBar = SnackBar(
      backgroundColor: colorScheme.tertiary,
      content: Row(
        children: [
          Icon(Icons.warning, color: contentColor),
          const SizedBox(width: 10),
          CustomAlignText(
              text: message,
              alignment: Alignment.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: contentColor,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
