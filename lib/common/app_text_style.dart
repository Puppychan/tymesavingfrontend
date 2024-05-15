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
}