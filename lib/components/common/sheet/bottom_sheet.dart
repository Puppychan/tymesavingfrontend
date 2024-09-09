import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';

void showStyledBottomSheet({
  required BuildContext context,
  String? title,
  String? subTitle,
  required Widget contentWidget,
  bool isTransparentBackground = false,
  double initialChildSize = 0.5, // -1 if want to fit the content
  VoidCallback?
      onNavigateToPreviousSheet, // Callback for navigating to previous sheet
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext modalContext) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: makeDismissible(
            context: modalContext,
            child: DraggableScrollableSheet(
              initialChildSize: initialChildSize,
              // minChildSize: 0.1,
              maxChildSize: 1,
              builder: (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: isTransparentBackground
                        ? Colors.transparent
                        : colorScheme.tertiary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                      controller: controller,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (onNavigateToPreviousSheet != null)
                            IconButton(
                              onPressed: () {
                                onNavigateToPreviousSheet();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 24.0,
                                semanticLabel: 'Back to previous page',
                              ),
                            ),
                          if (title != null)
                            CustomAlignText(
                                text: title, style: textTheme.headlineLarge),
                          const SizedBox(height: 10),
                          if (subTitle != null)
                            CustomAlignText(
                                text: subTitle,
                                style: textTheme.headlineMedium),
                          const SizedBox(height: 12),
                          // Expanded(
                          //   child: contentWidget,
                          // ),
                          contentWidget
                        ],
                      ))),
            ),
          ));
    },
  );
}

Widget makeDismissible({required Widget child, required BuildContext context}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      // dismiss keyboard
      dismissKeyboardAndAct(context);
      Navigator.of(context).pop();
    },
    child: GestureDetector(
        onTap: () {
          // dismiss keyboard
          dismissKeyboardAndAct(context);
        },
        child: child),
  );
}
