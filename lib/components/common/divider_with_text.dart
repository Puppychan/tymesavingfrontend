import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? lineColor;

  const DividerWithText({
    super.key,
    required this.text,
    this.textStyle,
    this.lineColor,
  });

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
          style: textStyle,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Divider(color: lineColor),
          ),
        ),
      ],
    );
  }
}
