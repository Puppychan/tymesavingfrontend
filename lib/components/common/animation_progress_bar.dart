import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final String tooltipMessage;
  final double height;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.tooltipMessage,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: GestureDetector(
          onTap:
              () {}, // Empty onTap to ensure GestureDetector captures tap events
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: progress.clamp(0.0, 1.0) *
                          MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
