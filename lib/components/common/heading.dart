import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const Heading(
      {super.key,
      required this.title,
      this.showBackButton = false,
      this.actions,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomAlignText(
          text: title, style: Theme.of(context).textTheme.headlineLarge),
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.maybePop(context);
                } else {
                  print("Can't pop the route, the history stack is empty.");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MainPageLayout();
                  }));
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                semanticLabel: 'Back to previous page',
              ),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
