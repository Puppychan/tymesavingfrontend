import 'package:flutter/material.dart';

class CustomAlignText extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final TextStyle? style;
  final int? maxLines;

  const CustomAlignText(
      {super.key, required this.text, this.alignment = Alignment.centerLeft, this.style, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: style,
        // textAlign: alignment,
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: maxLines,
      ),
    );
  }
}
