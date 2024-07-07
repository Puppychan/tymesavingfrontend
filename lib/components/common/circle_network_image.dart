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
    return Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).shadowColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: Theme.of(context).shadowColor,
                // spreadRadius: 2,
                offset: const Offset(0, 3)),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(imagePath),
        ));
  }
}
