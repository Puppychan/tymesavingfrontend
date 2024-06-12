import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color lineColor;

  const DividerWithText({
    Key? key,
    required this.text,
    this.textStyle,
    this.lineColor = AppColors.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: Divider(
              color: lineColor,
              height: 1.5,
            ),
          ),
        ),
        Text(
          text,
          style: textStyle ?? const TextStyle(color: AppColors.black),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Divider(
              color: lineColor,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
