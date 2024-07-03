import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const Heading(
      {super.key,
      required this.title,
      this.showBackButton = false,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomAlignText(text: title, style: Theme.of(context).textTheme.headlineLarge),
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                semanticLabel: 'Back to previous page',
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
