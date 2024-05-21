import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/error_page.dart';

class ErrorDisplay {
  static void showErrorToast(String? message, BuildContext context) {
    // handle null or empty message
    if (message == null || message.isEmpty == true) {
      return;
    }
    // if message is not null or empty, show snackbar
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void navigateToErrorPage(
      Map<String, dynamic> errorResponse, BuildContext context) {
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
