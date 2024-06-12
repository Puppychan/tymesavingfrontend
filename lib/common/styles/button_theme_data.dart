import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
// import 'package:tymesavingfrontend/enum/button_theme.dart';

class AppButtonThemeData {
  static Map<AppButtonTheme, ButtonStyle> getThemes(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return {
      AppButtonTheme.yellowBlack: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(colorScheme.inversePrimary),
        foregroundColor:
            MaterialStateProperty.all<Color>(colorScheme.onPrimaryContainer),
      ),
      AppButtonTheme.blueWhite: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(colorScheme.primary),
        foregroundColor:
            MaterialStateProperty.all<Color>(colorScheme.onPrimary),
      ),
      AppButtonTheme.whiteBlack: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(colorScheme.background),
        foregroundColor:
            MaterialStateProperty.all<Color>(colorScheme.onBackground),
      ),
    };
  }
}
