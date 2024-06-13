import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const Heading({super.key, required this.title, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);

    return AppBar(
      title: CustomAlignText(text: title),
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                // Navigator.pop(context);
                print("Back button pressed ${Navigator.canPop(context)}");
                // Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                semanticLabel: 'Back to previous page',
              ),
            )
          : null,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
