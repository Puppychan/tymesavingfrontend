// Function to handle errors during authentication
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/forbidden_page.dart';
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

    print("Result from handleAuthApi: $result");

    if (result['statusCode'] == 200) {
      await successAction();
    } else if (result['statusCode'] == 401 || result['statusCode'] == 400) {
      // Display error message
      context.loaderOverlay.hide();
      ErrorDisplay.showErrorToast(result['response'], context);
    } else {
      print("Error was thrown on handleAuthApi - inside $result");
      context.loaderOverlay.hide();
      ErrorDisplay.navigateToErrorPage(result, context);
    }
  } catch (e) {
    if (!context.mounted) return;
    context.loaderOverlay.hide();
    print("Error was thrown on handleAuthApi $e");
    // Display error message
    ErrorDisplay.navigateToErrorPage({'response': e.toString()}, context);
  }
}

// Function to handle errors inside the main page
Future<void> handleMainPageApi(
    BuildContext context,
    Future<dynamic> Function() mainPageAction,
    Future<void> Function() successAction,
    {Future<void> Function()? notFoundAction}) async {
  try {
    final result = await mainPageAction();

    // detect before call navigation
    if (!context.mounted) return;

    if (result['statusCode'] == 200) {
      await successAction();
    } else if (result['statusCode'] == 400) {
      context.loaderOverlay.hide();
      // Display error message
      ErrorDisplay.showErrorToast(result['response'], context);
    } else if (result['statusCode'] == 403) {
      context.loaderOverlay.hide();
      print("Forbidden page error: $result");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ForbiddenPage(errorMessage: result['response'] ?? "You're not allowed to access this page")));
    } else if (result['statusCode'] == 401) {
      // Display error message
      // ErrorDisplay.showErrorToast(result['response'], context);
      context.loaderOverlay.hide();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInView()),
          (_) => false);
    } else {
      context.loaderOverlay.hide();
      if (result['statusCode'] == 404 && notFoundAction != null) {
        ErrorDisplay.showErrorToast("Your Request Cannot Been Found", context);
        await notFoundAction();
        return;
      }

      Future.delayed(const Duration(seconds: 2), () {
        print("Error was thrown on handleMainPageApi - inside: $result");
        ErrorDisplay.navigateToErrorPage(result, context);
      });
    }
  } catch (e) {
    if (!context.mounted) return;
    print("Error was thrown on handleMainPageApi: $e");
    // Display error message
    context.loaderOverlay.hide();
    ErrorDisplay.navigateToErrorPage({'response': e.toString()}, context);
  }
}
