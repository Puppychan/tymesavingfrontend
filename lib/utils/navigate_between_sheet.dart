import 'package:flutter/material.dart';


void navigateSheetToSheet(BuildContext context, VoidCallback nextSheet) {
  Navigator.of(context).pop(); // Close the current bottom sheet
  Future.delayed(const Duration(milliseconds: 300), nextSheet); // Open the next sheet after a short delay
}