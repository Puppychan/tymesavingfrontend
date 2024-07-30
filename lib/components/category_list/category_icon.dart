import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';

Widget getCategoryIcon(
    {required Map<String, dynamic> currentCategoryInfo,
    bool? isSelected,
    ColorScheme? colorScheme}) {
  final bool isMarked = isSelected != null && isSelected;

  // return RoundedIcon(iconData: currentCategoryInfo['icon'], backgroundColor: currentCategoryInfo['color'], iconColor: Colors.white);
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
          padding: isSelected != null
              ? const EdgeInsets.all(10)
              : const EdgeInsets.all(0),
          child: RoundedIcon(
              iconData: currentCategoryInfo['icon'] ?? Icons.category,
              backgroundColor: currentCategoryInfo['color'],
              // padding: isMarked ? const EdgeInsets.all(10) : null,
              iconColor: Colors.white)),
      if (isMarked)
        Positioned(
            top: 1,
            right: 1,
            child:
                // Icon(Icons.check_circle, color: colorScheme?.primary, size: 30, iconColor: Colors.white),
                RoundedIcon(
                    iconData: Icons.check_rounded,
                    backgroundColor: colorScheme?.brightness == Brightness.dark
                        ? colorScheme?.primary
                        : colorScheme?.inversePrimary,
                    size: 28,
                    iconColor: colorScheme?.brightness == Brightness.dark
                        ? colorScheme?.onPrimary
                        : colorScheme?.onInverseSurface)),
    ],
  );
}
