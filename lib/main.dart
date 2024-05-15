import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/more_menu/more.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MoreMenu(),
    );
  }
}


