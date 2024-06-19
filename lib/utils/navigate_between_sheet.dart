import 'package:flutter/material.dart';

void navigateSheetToSheet (BuildContext context, Function actionFunction) {
    // await Future.delayed(const Duration(milliseconds: 300));

  Navigator.of(context).pop();
  actionFunction();
}
