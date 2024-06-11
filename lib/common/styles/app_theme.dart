import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.cream,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryBlue,
      background: AppColors.cream,
      surface: AppColors.cream, // Same as background
      onPrimary: AppColors.black,
      onSecondary: AppColors.white,
      onBackground: AppColors.black,
      onSurface: AppColors.black,
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
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primary,
      background: AppColors.black,
      surface: AppColors.black.withOpacity(0.8),
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onBackground: AppColors.white,
      onSurface: AppColors.white,
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
