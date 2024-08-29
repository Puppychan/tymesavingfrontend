import 'package:intl/intl.dart';

double convertFormattedAmountToNumber(String formattedAmount) {
  String numericString = formattedAmount.replaceAll(RegExp(r'[^\d]'), '');
  double? amount = double.tryParse(numericString);
  if (amount == null) {
    return 0.0;
  }
  return double.parse(amount.toStringAsFixed(2));
}

String formatAmountToVnd(double amount) {
  final NumberFormat formatter =
      NumberFormat.currency(decimalDigits: 0, symbol: '₫');
      // #,###,### ₫
  return formatter.format(amount);
}


String formatAmountWithCommas(double amount) {
  // Initialize a NumberFormat instance for formatting with commas
  final NumberFormat formatter = NumberFormat('#,##0', 'en_US');

  // Format the amount and add the currency symbol (₫)
  return formatter.format(amount);
}
