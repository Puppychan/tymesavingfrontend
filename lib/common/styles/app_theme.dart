import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

// ensure to call
// import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
// before using any custom theme: quaternary, onQuaternary, success

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    // primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.cream,
    brightness: Brightness.light,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.secondary,
      ),
      backgroundColor: AppColors.quaternary,
      // Adjust the top margin as needed
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
        borderRadius: BorderRadius.circular(10),

        fillColor: AppColors.primary, // background color when selected
        selectedBorderColor: AppColors.quaternary, // border color when selected
        selectedColor: AppColors.black, // text color when selected
        splashColor: AppColors.tertiary
            .withOpacity(0.5), // color when pressed - animated color
        borderColor: AppColors.quaternary, // border color when not selected
        color: AppColors.secondary // text color when not selected
        ),
    colorScheme: const ColorScheme.light(
      // primary: AppColors.primary,
      primary: AppColors.primaryBlue,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.white,
      // secondary: AppColors.primaryBlue,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      background: AppColors.cream,
      error: AppColors.error,

      onPrimary: AppColors.cream,
      onPrimaryContainer: AppColors.black,
      onInverseSurface: AppColors.black,
      onSecondary: AppColors.cream,
      onTertiary: AppColors.black,
      onBackground: AppColors.black,
      onError: AppColors.errorText,

      // shadow: AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.cream, // background color of the app bar
      surfaceTintColor: AppColors.cream, // color of the app bar when scrolling
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
          // display
          fontSize: 28,
          color: AppColors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          // display
          fontSize: 28,
          color: AppColors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          // sub display - subheading
          fontSize: 22,
          color: AppColors.black,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      titleLarge: TextStyle(
          // heading medium
          color: AppColors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
          // sub heading medium
          fontSize: 18,
          color: AppColors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      titleSmall: TextStyle(
          // heading small
          fontSize: 15,
          color: AppColors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      // bodyLarge: TextStyle(color: AppColors.black),
      bodyLarge: TextStyle(
          // body as input
          color: AppColors.secondary,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          // body
          color: AppColors.secondary,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),

      bodySmall: TextStyle(
          // sub body
          fontSize: 14,
          color: Color.fromRGBO(78, 78, 83, 1),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
        // input label
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
        fontFamily: 'Montserrat',
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.black),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.cream,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      surfaceTintColor: AppColors.navBackground,
      color: AppColors.navBackground,
      shadowColor: AppColors.navBackgroundShadow,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1.5,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    // primaryColor: AppColors.primaryBlue,
    // primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.black,
    brightness: Brightness.dark,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.secondaryDark,
      ),
      backgroundColor: AppColors.quaternaryDark,
      // Adjust the top margin as needed
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
        borderRadius: BorderRadius.circular(10),

        fillColor: AppColors.primaryBlueDark, // background color when selected
        selectedBorderColor: AppColors.quaternaryDark, // border color when selected
        selectedColor: AppColors.black, // text color when selected
        splashColor: AppColors.tertiaryDark
            .withOpacity(0.5), // color when pressed - animated color
        borderColor: AppColors.quaternaryDark, // border color when not selected
        color: AppColors.secondaryDark // text color when not selected
        ),
    colorScheme: const ColorScheme.dark(
      // primary: AppColors.primary,
      primary: AppColors.primaryBlueDark,
      inversePrimary: AppColors.primary,
      // secondary: AppColors.primaryBlue,
      surfaceTint: AppColors.black,
      secondary: AppColors.secondaryDark,
      tertiary: AppColors.tertiaryDark,
      background: AppColors.black,
      error: AppColors.errorDark,

      onPrimary: AppColors.black,
      onPrimaryContainer: AppColors.black,
      onInverseSurface: AppColors.black,
      onSecondary: AppColors.black,
      onTertiary: AppColors.white,
      onBackground: AppColors.cream,
      onError: AppColors.errorTextDark,

      // shadow: AppColors.secondaryDark,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.black, // background color of the app bar
      surfaceTintColor: AppColors.black, // color of the app bar when scrolling
      iconTheme: IconThemeData(color: AppColors.cream),
      titleTextStyle: TextStyle(
          // display
          fontSize: 28,
          color: AppColors.cream,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          // display
          fontSize: 28,
          color: AppColors.cream,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          // sub display
          fontSize: 22,
          color: AppColors.cream,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      titleLarge: TextStyle(
          // heading medium
          color: AppColors.cream,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
          // sub heading medium
          fontSize: 18,
          color: AppColors.cream,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      titleSmall: TextStyle(
          // heading small
          fontSize: 15,
          color: AppColors.cream,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w700),
      // bodyLarge: TextStyle(color: AppColors.cream),
      bodyLarge: TextStyle(
          // body as input
          color: AppColors.secondaryDark,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          // body
          color: AppColors.secondaryDark,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),

      bodySmall: TextStyle(
          // sub body
          fontSize: 14,
          color: AppColors.secondaryDark,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
        // input label
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryDark,
        fontFamily: 'Montserrat',
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlueDark,
      foregroundColor: AppColors.black,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
        surfaceTintColor: AppColors.navBackgroundDark,
        color: AppColors.navBackgroundDark,
        shadowColor: AppColors.navBackgroundShadowDark),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
    ),
  );
}
