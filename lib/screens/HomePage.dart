import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(fontSize: 24)),
    );
  }
}