import 'package:flutter/material.dart';

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
  // TODO: add a method to navigate to error page later
}
