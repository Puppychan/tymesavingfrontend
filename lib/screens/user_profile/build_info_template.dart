import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';


class BuildInfo extends StatelessWidget {
  const BuildInfo(this.label, this.value, this.icon, {super.key});

  final String label;
  final String value;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(width: 5,height: 10,),
            Text(label,style: AppTextStyles.headingSmall),
            
            Text(value, style: AppTextStyles.subHeadingSmall,),
          ],),
          const Expanded(child: SizedBox(),),
          Icon(icon.icon, color: AppColors.primaryBlue, size: 25),
          ]
        ),
      )
    );
  }
}