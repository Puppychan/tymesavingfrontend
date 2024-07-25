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
              WidgetStateProperty.all<Color>(colorScheme.inversePrimary),
          foregroundColor:
              WidgetStateProperty.all<Color>(colorScheme.onPrimaryContainer),
          textStyle: WidgetStateProperty.all<TextStyle>(
            textStyle.copyWith(color: colorScheme.onPrimaryContainer),
          )),
      AppButtonTheme.blueWhite: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(colorScheme.primary),
        foregroundColor:
            WidgetStateProperty.all<Color>(colorScheme.onPrimary),
        textStyle: WidgetStateProperty.all<TextStyle>(
          textStyle.copyWith(color: colorScheme.onPrimary),
        ),
      ),
      AppButtonTheme.whiteBlack: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(colorScheme.tertiary),
        foregroundColor:
            WidgetStateProperty.all<Color>(colorScheme.onTertiary),
        // overlayColor: MaterialStateProperty.all<Color>(colorScheme.primary),
        textStyle: WidgetStateProperty.all<TextStyle>(
          textStyle.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    };
  }
}
