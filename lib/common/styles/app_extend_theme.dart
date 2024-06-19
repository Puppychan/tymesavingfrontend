import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

// ensure to call
// import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
// before using this extension

extension ExtendColorScheme on ColorScheme {
  Color get quaternary => brightness == Brightness.dark ? AppColors.quaternaryDark : AppColors.quaternary;
  Color get onQuaternary => brightness == Brightness.dark ? AppColors.secondaryDark : AppColors.secondary;
  Color get success => AppColors.positive;
  Color get onSuccess => AppColors.black;
}