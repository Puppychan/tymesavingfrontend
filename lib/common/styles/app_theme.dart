import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.cream,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      // primary: AppColors.primary,
      primary: AppColors.primaryBlue,
      inversePrimary: AppColors.primary,
      // surfaceTint: AppColors.white,
      // secondary: AppColors.primaryBlue,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.quaternary,
      background: AppColors.cream,

      onPrimary: AppColors.cream,
      onPrimaryContainer: AppColors.black,
      onInverseSurface: AppColors.black,
      onSecondary: AppColors.cream,
      onBackground: AppColors.black,
      onSurface: AppColors.black,
      error: AppColors.error,

      shadow: AppColors.secondary,

    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.cream, // background color of the app bar
      surfaceTintColor: AppColors.cream, // color of the app bar when scrolling
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(color: AppColors.black, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.secondary),
    ),
    iconTheme: const IconThemeData(color: AppColors.black),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.black,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      // primary: AppColors.primary,
      primary: AppColors.primaryBlueDark,
      inversePrimary: AppColors.primary,
      // surfaceTint: Colors.transparent,
      // secondary: AppColors.primaryBlue,
      secondary: AppColors.secondaryDark,
      tertiary: AppColors.tertiaryDark,
      surface: AppColors.quaternaryDark,
      background: AppColors.black,
      error: AppColors.error,

      onPrimary: AppColors.cream,
      onPrimaryContainer: AppColors.black,
      onSecondary: AppColors.black,
      onBackground: AppColors.cream,
      onSurface: AppColors.cream,

      // shadow: BoxShadow(
      //   color: AppColors.secondary.withOpacity(0.16),
      //   offset: Offset(0, 4),
      //   blurRadius: 4,
      // ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.black, // background color of the app bar
      surfaceTintColor: AppColors.black, // color of the app bar when scrolling
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(color: AppColors.white, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.quaternary),
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.black,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.tertiary,
    ),
  );
}
