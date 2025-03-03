import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
import 'package:tymesavingfrontend/common/styles/button_theme_data.dart';
import 'package:tymesavingfrontend/utils/dismiss_keyboard.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AppButtonTheme theme;

  const PrimaryButton({super.key, 
    required this.title,
    required this.onPressed,
    this.theme = AppButtonTheme.yellowBlack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            dismissKeyboardAndAct(context);
            onPressed();
          },
          style: AppButtonThemeData.getThemes(context)[theme]!.copyWith(
            elevation: MaterialStateProperty.all(3),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                  vertical: 13), // Adjust padding to your needs
            ),
          ),
          child: Text(title),
        ));
  }
}
