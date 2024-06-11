// Function to handle errors during authentication
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';

Future<void> handleAuthApi(
    BuildContext context,
    Future<dynamic> Function() authAction,
    Future<void> Function() successAction) async {
  // call api from backend to signin
  try {
    // final result = await authService.signIn(
    //   _usernameController.text,
    //   _passwordController.text,
    // );
    final result = await authAction();

    // detect before call navigation
    if (!context.mounted) return;

    if (result['statusCode'] == 200) {
      await successAction();
    } else if (result['statusCode'] == 401 || result['statusCode'] == 400) {
      // Display error message
      ErrorDisplay.showErrorToast(result['response'], context);
    } else {
      ErrorDisplay.navigateToErrorPage(result, context);
    }
  } catch (e) {
    if (!context.mounted) return;

    // Display error message
    ErrorDisplay.navigateToErrorPage({'response': e.toString()}, context);
  }
}

// Function to handle errors inside the main page
Future<void> handleMainPageApi(
    BuildContext context,
    Future<dynamic> Function() mainPageAction,
    Future<void> Function() successAction) async {
  try {
    final result = await mainPageAction();

    // detect before call navigation
    if (!context.mounted) return;

    if (result['statusCode'] == 200) {
      await successAction();
    } else if (result['statusCode'] == 401 || result['statusCode'] == 400) {
      // Display error message
      // ErrorDisplay.showErrorToast(result['response'], context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInView()),
          (_) => false);
    } else {
      ErrorDisplay.navigateToErrorPage(result, context);
    }
  } catch (e) {
    if (!context.mounted) return;

    // Display error message
    ErrorDisplay.navigateToErrorPage({'response': e.toString()}, context);
  }
}
