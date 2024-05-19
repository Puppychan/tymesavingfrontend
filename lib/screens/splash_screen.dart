import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/screens/HomePage.dart';
import 'package:tymesavingfrontend/screens/sign_in_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    // Add your initialization code here
    Future.delayed(const Duration(seconds: 2), () {
      authService.tryAutoLogin().then((isLoggedIn) {
        if (isLoggedIn) {
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(title: 'Home')));
        } else {
          // Navigator.pushReplacementNamed(context, '/login');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignInView()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Top blue shape
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              color: Colors.blue[900], // Adjust color as needed
              transform: Matrix4.rotationZ(-13.48), // Adjust rotation as needed
            ),
          ),
          // Bottom yellow shape
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              color: Colors.yellow[700], // Adjust color as needed
              transform: Matrix4.rotationZ(0.1), // Adjust rotation as needed
            ),
          ),
          // Logo in the center
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/img/app_logo_light.png', // Replace with your logo image path
                  width: screenWidth * 0.5, // Adjust logo size as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
