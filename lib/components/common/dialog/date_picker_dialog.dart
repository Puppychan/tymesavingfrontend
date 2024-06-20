import 'package:flutter/material.dart';
// Theme.of(context).copyWith(
// colorScheme: ColorScheme.light(
// primary: Colors.yellow, // header background color
// onPrimary: Colors.black, // header text color
// onSurface: Colors.green, // body text color
// ),
// textButtonTheme: TextButtonThemeData(
// style: TextButton.styleFrom(
//   foregroundColor: Colors.red, // button text color
// ),
// )

Future<DateTime?> showCustomDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  // required Function(DateTime) onDateSelected,
  String? helpText,
}) async {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    helpText: helpText,
    confirmText: 'Choose',
    errorFormatText: 'Enter valid date',
    errorInvalidText: 'Enter date in valid range',
 
  );
}
