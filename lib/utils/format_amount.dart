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
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return formatter.format(amount);
}
