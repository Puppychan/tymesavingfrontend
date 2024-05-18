import 'package:flutter/painting.dart';
import 'package:tymesavingfrontend/common/app_color.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.primaryText,
    fontSize: 30,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle subHeading = TextStyle(
    color: AppColors.primaryText,
    fontSize: 20,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.primaryText,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inputLabel = TextStyle(
    color: AppColors.primaryText,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headingMedium = TextStyle(
    color: AppColors.primaryText,
    fontSize: 20,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle subHeadingMedium = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headingSmall = TextStyle(
    color: AppColors.primaryText,
    fontSize: 15,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle subHeadingSmall = TextStyle(
    color: AppColors.primaryText,
    fontSize: 14,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle boldHeadingBlue = TextStyle(
    color: AppColors.primaryBlue,
    fontSize: 20,
    fontFamily: 'Merriweather',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle paragraph = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontFamily: 'Monsterrat',
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle paragraphLink = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    height: 1.5,
    fontFamily: 'Monsterrat',
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
}
