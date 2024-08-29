import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  CurrencyInputFormatter({String locale = 'en_US'})
      : _formatter = NumberFormat.currency(locale: locale, symbol: '', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse the cleaned string to a number
    final num parsedNumber = int.parse(newText.isNotEmpty ? newText : '0');

    // Format the number as a currency string without a symbol
    final String newFormattedText = _formatter.format(parsedNumber);

    // Calculate the new cursor position
    int newSelectionIndex = _calculateNewCursorIndex(oldValue, newValue, newFormattedText);

    // Return the formatted value, with the updated cursor position
    return TextEditingValue(
      text: newFormattedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }

  int _calculateNewCursorIndex(TextEditingValue oldValue, TextEditingValue newValue, String newFormattedText) {
    // Get the original cursor position and the difference in length from non-digit character removal
    int oldCursorIndex = oldValue.selection.baseOffset;
    int cursorIndexAfterDigitRemoval = newValue.selection.baseOffset;

    // 50,0|00 500,0|00 -> 50,000

    print("Old cursor index: ${oldValue.selection}");

    // Factor in the removal of non-digits up to the cursor position
    String oldTextUpToCursor = oldValue.text.substring(0, oldCursorIndex);
    int nonDigitsBeforeCursor = RegExp(r'[^\d]').allMatches(oldTextUpToCursor).length;
    cursorIndexAfterDigitRemoval -= nonDigitsBeforeCursor;

    // If backspacing right after a comma, adjust cursor to skip comma
    if (oldValue.text.length > newValue.text.length && // If text length reduced
        oldCursorIndex > 0 && // Not at start
        oldValue.text[oldCursorIndex - 1] == ',') { // Just deleted a comma
      cursorIndexAfterDigitRemoval -= 1; // Skip the comma
    }

    // Adjust for the number of commas in the new formatted text before the new cursor index
    int commasInFormattedTextBeforeCursor = RegExp(r',')
      .allMatches(newFormattedText.substring(0, cursorIndexAfterDigitRemoval))
      .length;
    
    // Adjust cursor position forward by the number of commas added in formatted text
    int adjustedCursorIndex = cursorIndexAfterDigitRemoval + commasInFormattedTextBeforeCursor;
    adjustedCursorIndex = adjustedCursorIndex.clamp(0, newFormattedText.length); // Ensure within bounds

    return adjustedCursorIndex;
  }
}
