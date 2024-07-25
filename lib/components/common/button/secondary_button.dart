import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
import 'package:tymesavingfrontend/common/styles/button_theme_data.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AppButtonTheme theme;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.theme = AppButtonTheme.whiteBlack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: AppButtonThemeData.getThemes(context)[theme]!.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 13),
            ),
            elevation: WidgetStateProperty.all(5),
          ),
          child: Text(title),
        ));
  }
}
