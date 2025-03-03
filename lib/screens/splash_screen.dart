import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  String name = '';
  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    // Add your initialization code here
    Future.delayed(const Duration(seconds: 1), () {
      authService.tryAutoLogin().then((isLoggedIn) {
        // ErrorDisplay.showErrorToast("Is Logged In: $isLoggedIn", context);
        if (isLoggedIn) {
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainPageLayout()));
                  // builder: (context) => const ErrorPage(
                  //       errorMessage: 'An error occurred!',
                  //       statusCode: 500,)));
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Image.asset(
        'assets/img/${isDarkTheme ? "splash_dark" : "splash_light"}.png',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      )
    );
  }
}
