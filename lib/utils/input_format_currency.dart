import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  CurrencyInputFormatter({String locale = 'en_US'})
      : _formatter =
            NumberFormat.currency(locale: locale, symbol: '', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String numericOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    int? newValueInt = int.tryParse(numericOnly);
    if (newValueInt == null) return newValue; // Guard against invalid input

    // Format the number as a currency string without a symbol
    String newFormattedText = _formatter.format(newValueInt);

    // Calculate the new cursor position
    int newSelectionIndex =
        _calculateNewCursorIndex(oldValue, newValue, newFormattedText);

    return TextEditingValue(
      text: newFormattedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }

  int _calculateNewCursorIndex(TextEditingValue oldValue,
      TextEditingValue newValue, String newFormattedText) {

    // Find out where the cursor was right after the last digit in the old value
    int oldPosition = oldValue.selection.baseOffset;
    int newPosition = oldPosition;

    // Calculate difference in length caused by digit addition or removal
    // int lengthDiff = newValue.text.replaceAll(RegExp(r'[^\d]'), '').length -
    //     oldValue.text.replaceAll(RegExp(r'[^\d]'), '').length;
    int lengthDiff = newFormattedText.length - oldValue.text.length;

    // Adjust the cursor position based on length difference
    newPosition += lengthDiff;

    // Make sure the new cursor position does not exceed the length of the new formatted text
    newPosition = min(newFormattedText.length, newPosition);

    return newPosition >= 0 ? newPosition : 0;
  }
}
