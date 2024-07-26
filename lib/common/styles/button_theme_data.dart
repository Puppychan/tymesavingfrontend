import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
// import 'package:tymesavingfrontend/enum/button_theme.dart';

class AppButtonThemeData {
  static Map<AppButtonTheme, ButtonStyle> getThemes(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final TextStyle textStyle = Theme.of(context).textTheme.labelLarge!;
    return {
      AppButtonTheme.yellowBlack: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(colorScheme.inversePrimary),
          foregroundColor:
              MaterialStateProperty.all<Color>(colorScheme.onPrimaryContainer),
          textStyle: MaterialStateProperty.all<TextStyle>(
            textStyle.copyWith(color: colorScheme.onPrimaryContainer),
          )),
      AppButtonTheme.blueWhite: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(colorScheme.primary),
        foregroundColor:
            MaterialStateProperty.all<Color>(colorScheme.onPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(
          textStyle.copyWith(color: colorScheme.onPrimary),
        ),
      ),
      AppButtonTheme.whiteBlack: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(colorScheme.tertiary),
        foregroundColor:
            MaterialStateProperty.all<Color>(colorScheme.onTertiary),
        // overlayColor: MaterialStateProperty.all<Color>(colorScheme.primary),
        textStyle: MaterialStateProperty.all<TextStyle>(
          textStyle.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    };
  }
}
