import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final String imagePath;

  const CustomCircleAvatar({
    super.key,
    this.radius = 30.0,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      // shadowColor: AppColors.secondary.withOpacity(0.2),
      backgroundImage: NetworkImage(imagePath),
    );
  }
}