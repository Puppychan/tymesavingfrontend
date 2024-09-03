import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showHomeButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const Heading(
      {super.key,
      required this.title,
      this.showBackButton = false,
      this.actions,
      this.bottom,
      this.showHomeButton = false});

  @override
  Widget build(BuildContext context) {
    IconButton? showLeadingButton() {
      if (showBackButton) {
        return IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.maybePop(context);
            } else {
              debugPrint("Can't pop the route, the history stack is empty.");
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
        );
      } else if (showHomeButton) {
        return IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPageLayout()),
                (_) => false);
          },
          icon: const Icon(
            Icons.home,
            size: 24.0,
            semanticLabel: 'Back to home page',
          ),
        );
      } else {
        return null;
      }
    }

    return AppBar(
      title: CustomAlignText(
          text: title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500)),
      leading: showLeadingButton(),
      actions: actions,
      bottom: bottom,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
