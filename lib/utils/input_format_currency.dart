import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = convertFormattedAmountToNumber(newValue.text);
    final newText = formatAmountToVnd(value);

    // Calculate the cursor position adjustment
    int cursorPosition = newValue.selection.end;
    int diff = newValue.text.length - oldValue.text.length;

    // Adjust the cursor position after formatting
    cursorPosition -= diff;

    // Ensure the cursor position is not out of bounds
    cursorPosition = cursorPosition.clamp(0, newText.length);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  double convertFormattedAmountToNumber(String formattedAmount) {
    String numericString = formattedAmount.replaceAll(RegExp(r'[^\d]'), '');
    double? amount = double.tryParse(numericString);
    if (amount == null) {
      return 0.0;
    }
    return double.parse(amount.toStringAsFixed(2));
  }

  String formatAmountToVnd(double amount) {
    return currencyFormatter.format(amount);
  }
}