import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';

void showStyledBottomSheet({
  required BuildContext context,
  // required List<dynamic> itemList, // Replace dynamic with your actual item type
  String? title,
  String? subTitle,
  required Widget contentWidget, // Adjust the type accordingly

  bool isTransparentBackground = false,
  double initialChildSize = 0.5, // -1 if want to fit the content
  // Widget? headingButtons,
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
      return makeDismissible(
        context: modalContext,
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          // minChildSize: 0.1,
          maxChildSize: 1,
          builder: (_, controller) => Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(
                color: isTransparentBackground
                    ? Colors.transparent
                    : colorScheme.tertiary,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
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
                  if (subTitle !=
                      null) // Use collection-if to conditionally add a widget
                    CustomAlignText(
                        text: subTitle, style: textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Expanded(
                      child: SingleChildScrollView(
                    controller: controller,
                    child: contentWidget,
                  )),
                ],
              )),
        ),
      );
    },
  );
}

Widget makeDismissible({required Widget child, required BuildContext context}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );
}
