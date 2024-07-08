import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final IconData iconData;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const RoundedIcon({
    super.key,
    required this.iconData,
    this.backgroundColor, // Default background color
    this.iconColor, // Default icon color
    this.size = 50.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .shadow,
            spreadRadius: 2, // Spread radius
            blurRadius: 4, // Blur radius
            offset: const Offset(0, 2),
          ),
        ],
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
