import 'package:flutter/material.dart';

Future<TimeOfDay?> showCustomTimePickerDialog({
  required BuildContext context,
  required TimeOfDay initialTime,
  // required Function(DateTime) onDateSelected,
  String? helpText,
}) async {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: helpText,
    confirmText: 'Choose',
    errorInvalidText: 'Enter time in valid range',
  );
}
