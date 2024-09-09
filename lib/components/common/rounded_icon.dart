import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final IconData iconData;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool hasShadow;
  final double size;

  const RoundedIcon({
    super.key,
    required this.iconData,
    this.backgroundColor, // Default background color
    this.iconColor, // Default icon color
    this.size = 50.0,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: hasShadow ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 1, // Spread radius
            blurRadius: 1, // Blur radius
            offset: const Offset(0, 1),
          ),
        ] : null,
      ),
      alignment: Alignment.center,
      child: Icon(
        iconData,
        color: iconColor,
        size: size * 0.6, // Icon size is 60% of the container size
      ),
    );
  }
}
