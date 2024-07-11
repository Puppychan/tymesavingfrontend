import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/error_page.dart';

class ErrorDisplay {
  static void showErrorToast(String? message, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // handle null or empty message
    if (message == null || message.isEmpty == true) {
      return;
    }
    // if message is not null or empty, show snackbar
    final snackBar = SnackBar(
      backgroundColor: colorScheme.error,
      content: Text(message, style: TextStyle(color: colorScheme.onError)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void navigateToErrorPage(
      Map<String, dynamic> errorResponse, BuildContext context) {
    // check if already in error page
    bool alreadyInErrorPage = false;
    var currentRoute = ModalRoute.of(context);
    if (currentRoute != null &&
        currentRoute.settings.name == ErrorPage.routeName) {
      alreadyInErrorPage = true;
    }
    if (!alreadyInErrorPage) {
      // Display error message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            errorMessage:
                errorResponse['response'] ?? "Oops something went wrong",
            statusCode: errorResponse['statusCode'] ?? 500,
          ),
        ),
      );
    }
  }
}
