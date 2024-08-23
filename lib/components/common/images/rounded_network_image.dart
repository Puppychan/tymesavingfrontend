import 'package:flutter/material.dart';

class CustomRoundedImage extends StatelessWidget {
  final double size;
  final String imagePath;

  const CustomRoundedImage({
    super.key,
    this.size = 30.0,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imagePath),
        ),
      ),
    );
  }
}
