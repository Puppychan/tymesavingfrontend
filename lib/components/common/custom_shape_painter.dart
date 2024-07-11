import 'package:flutter/material.dart';

class CustomShapePainter extends CustomPainter {
  static const double padding = 20;
  final Color? color; // Remove this line
  final Gradient? gradient; // Add this line

  CustomShapePainter(
      {this.gradient, this.color}); // Modify constructor
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    // Customize your paint (color, stroke, style)
    paint.color = color!;

    // Apply the gradient to the paint
    paint.shader =
        gradient?.createShader(Rect.fromLTWH(0, 0, size.width + padding, size.height));
    // paint.style =
    //     PaintingStyle.fill; // Change this to .stroke if you want an outline
    paint.style = PaintingStyle.fill;

    var path = Path();

    // start from bottom left
    path.moveTo(-padding, size.height * 0.75);
    // first curve at the bottom
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.75);
    // bottom right - second curve
    path.quadraticBezierTo(size.width * 0.75, size.height, size.width + padding,
        size.height * 0.75);
    // top right (height: padding size, width: size.width + padding)
    path.lineTo(size.width + padding, padding);
    // first curve at the top
    // x1, y1 is the control point for the curve. Adjust these values to change the curve's shape
    // x2, y2 is the end point of the curve. This should be on the top edge, but to the left of the top right corner
    path.quadraticBezierTo(
        size.width * 0.85, -size.height * 0.2, size.width * 0.65, padding);
    // top left
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.45, size.width * 0.25, padding);
    path.quadraticBezierTo(size.width * 0.1, -size.height * 0.25, -padding, padding);
    // path.lineTo(-padding, 0);
    path.close();

    // path.lineTo(0, size.height);
    // path.quadraticBezierTo(size.width / 2, size.height - 100, size.width, size.height);
    // path.lineTo(size.width, 0);
    // path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
