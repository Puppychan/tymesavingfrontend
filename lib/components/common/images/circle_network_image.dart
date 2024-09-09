import 'dart:io';

import 'package:flutter/material.dart';

class CustomCircleImage extends StatelessWidget {
  final double radius;
  final String imagePath;
  final String fallbackImagePath;

  const CustomCircleImage({
    super.key,
    this.radius = 30.0,
    required this.imagePath,
    this.fallbackImagePath = "assets/img/app_logo_light.png",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Theme.of(context).shadowColor,
        shape: BoxShape.circle,
        boxShadow: [
          // BoxShadow(
          //     blurRadius: 5,
          //     color: Theme.of(context).shadowColor,
          //     // spreadRadius: 2,
          //     offset: const Offset(0, 3)),
        ],
      ),
      child: imagePath.startsWith("http")
          ? CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(imagePath),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading errors
                Image.asset(fallbackImagePath);
              },
            )
          : ClipOval(
              child: Image.file(
              File(imagePath),
              width: radius * 2, // diameter
              height: radius * 2,
            )),
    );
  }
}
