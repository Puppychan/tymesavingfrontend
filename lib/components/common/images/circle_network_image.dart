import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final String imagePath;
  final String fallbackImagePath;

  const CustomCircleAvatar({
    super.key,
    this.radius = 30.0,
    required this.imagePath,
    this.fallbackImagePath = "assets/img/app_logo_light.png",
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
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading errors
            Image.asset(fallbackImagePath);
          },
          // child: Image.network(
          //   imagePath,
          //   errorBuilder: (context, error, stackTrace) {
          //     // Return a fallback widget in case of error
          //     return CircleAvatar(
          //       radius: radius,
          //       backgroundImage: AssetImage(fallbackImagePath),
          //     );
          //   },
          // ),
        ));
  }
}
