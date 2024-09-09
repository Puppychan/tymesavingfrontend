import 'package:flutter/material.dart';

class AppTextStyles {
  //   static const TextStyle heading = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 28,
  //   fontWeight: FontWeight.w700,
  // );

  // static const TextStyle subHeading = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 20,
  //   fontFamily: 'Montserrat',
  //   fontWeight: FontWeight.w400,
  // );

  // static const TextStyle button = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 14,
  //   fontFamily: 'Montserrat',
  //   fontWeight: FontWeight.w600,
  // );

  // static const TextStyle inputLabel = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 16,
  //   fontFamily: 'Montserrat',
  //   fontWeight: FontWeight.w600,
  // );

  // static const TextStyle headingMedium = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 20,
  //   fontWeight: FontWeight.w700,
  // );

  // static const TextStyle subHeadingMedium = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 18,
  //   fontWeight: FontWeight.w700,
  // );

  // static const TextStyle headingSmall = TextStyle(
  //   // color: AppColors.primaryText,
  //   fontSize: 15,
  //   fontWeight: FontWeight.w700,
  // );

  // static const TextStyle subHeadingSmall = TextStyle(
  //   color: AppColors.primaryText,
  //   fontSize: 14,
  //   fontWeight: FontWeight.w400,
  // );

  // static const TextStyle boldHeadingBlue = TextStyle(
  //   // color: AppColors.primaryBlue,
  //   fontSize: 20,
  //   fontWeight: FontWeight.w500,
  // );

  // static const TextStyle paragraph = TextStyle(
  //   // color: AppColors.secondary,
  //   fontSize: 14,
  //   fontFamily: 'Monsterrat',
  //   height: 1.5,
  //   fontWeight: FontWeight.w400,
  // );

  static const TextStyle graphData = TextStyle(
    // color: AppColors.secondary,
    fontSize: 11,
    fontFamily: 'Monsterrat',
    height: 1,
    fontWeight: FontWeight.w400,
  );

  static TextStyle titleLargeBlue(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
  }

  static TextStyle paragraphBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.w600, height: 1.5);
  }

  static TextStyle paragraphLinkBlue(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.5,
          decoration: TextDecoration.underline,
          decorationColor: colorScheme.primary,
          color: colorScheme.primary,
        );
  }

  static TextStyle paragraphLinkYellow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.5,
          decoration: TextDecoration.underline,
          decorationColor: colorScheme.inversePrimary,
          color: colorScheme.inversePrimary,
        );
  }
}
