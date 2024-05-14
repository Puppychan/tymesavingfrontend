import 'package:flutter/material.dart';

class CustomAlignText extends StatelessWidget {
  final String text;
  final TextAlign alignment;
  final TextStyle style;

  const CustomAlignText(
      {super.key, required this.text, this.alignment = TextAlign.left, required this.style});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: style,
        textAlign: alignment,
        textWidthBasis: TextWidthBasis.longestLine,
      ),
    );
  }
}
