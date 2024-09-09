import 'package:flutter/material.dart';

void dismissKeyboardAndAct(BuildContext context) {
  var currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   action();
    // });
  } else {
    // action();
  }
}
