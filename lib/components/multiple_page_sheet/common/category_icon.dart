import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';

Widget getCategoryIcon(Map<String, dynamic> currentCategoryInfo) {
  return RoundedIcon(iconData: currentCategoryInfo['icon'], backgroundColor: currentCategoryInfo['color'], iconColor: Colors.white);
}