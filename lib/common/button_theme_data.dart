import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/enum/button_theme.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
// import 'package:tymesavingfrontend/enum/button_theme.dart';

class AppButtonThemeData {
  static final Map<AppButtonTheme, ButtonStyle> themes = {
    AppButtonTheme.yellowBlack: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
      foregroundColor: MaterialStateProperty.all<Color>(AppColors.gray),
    ),
    AppButtonTheme.darkBlueWhite: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryBlue),
      foregroundColor: MaterialStateProperty.all<Color>(AppColors.cream),
    ),
    // AppButtonTheme.lightBlueWhite: ButtonStyle(
    //   backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
    //   foregroundColor: MaterialStateProperty.all<Color>(Colors.cream),
    // ),
    AppButtonTheme.whiteBlack: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.cream),
      foregroundColor: MaterialStateProperty.all<Color>(AppColors.gray),
    ),
  };
}
