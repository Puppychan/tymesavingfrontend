import 'dart:math';
import 'package:flutter/material.dart';

class GroupSavingHalfProgressBar extends StatefulWidget {
  const GroupSavingHalfProgressBar({
    super.key, 
    required this.amount, 
    required this.concurrent
  });

  final double amount;
  final double concurrent;

  @override
  State<GroupSavingHalfProgressBar> createState() => _GroupSavingHalfProgressBarState();
}

class _GroupSavingHalfProgressBarState extends State<GroupSavingHalfProgressBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(200, 100),
                painter: HalfProgressBarPainter(
                  amount: widget.amount,
                  backgroundColor: Colors.grey,
                  progressColor: colorScheme.primary,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 45,),
                  Text.rich(
                    TextSpan(text: 
                      '${widget.amount.toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text('complete', style: Theme.of(context).textTheme.headlineMedium,)
                ]
              )
            ]
          ),
          const SizedBox(height: 10),
          
        ],
      ),
    );
  }
}

class HalfProgressBarPainter extends CustomPainter {
  final double amount;
  final Color backgroundColor;
  final Color progressColor;

  HalfProgressBarPainter({
    required this.amount,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = min(size.width / 2, size.height);

    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height), width: size.width, height: size.height * 2),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    double sweepAngle = pi * (amount / 100);

    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height), width: size.width, height: size.height * 2),
      pi,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
