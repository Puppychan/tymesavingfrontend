import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/enum/button_theme.dart';
import 'package:tymesavingfrontend/common/button_theme_data.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AppButtonTheme theme;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.theme = AppButtonTheme.yellowBlack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: AppButtonThemeData.themes[theme]?.copyWith(
            elevation: MaterialStateProperty.all(5), // Add shadow
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 10), // Adjust padding to your needs
            ),
          ),
          child: Text(
            title,
            style: AppTextStyles.button,
          ),
        ));
  }
}
