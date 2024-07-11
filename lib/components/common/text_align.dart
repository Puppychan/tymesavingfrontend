import 'package:flutter/material.dart';

class CustomAlignText extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

  const CustomAlignText(
      {super.key, required this.text, this.alignment = Alignment.centerLeft, this.style, this.maxLines, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: maxLines,
      ),
    );
  }
}
