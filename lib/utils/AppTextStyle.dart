import 'package:flutter/painting.dart';
import 'package:tymesavingfrontend/utils/AppColor.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.primaryText,
    fontSize: 30,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subHeading = TextStyle(
    color: AppColors.primaryText,
    fontSize: 14,
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
    color: AppColors.secondaryText,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );
}