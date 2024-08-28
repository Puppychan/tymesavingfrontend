import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_item.dart';
import 'dart:math';
import 'package:tymesavingfrontend/models/transaction_model.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool disableButton;

  TransactionList({super.key, required this.transactions, this.disableButton = false});

  final List<IconData> icons = [
    Icons.shopping_cart,
    Icons.directions_car,
    Icons.local_dining,
    Icons.movie,
    Icons.card_giftcard,
    Icons.flight,
    Icons.home,
  ];

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
  ];

  IconData getRandomIcon() {
    final random = Random();
    return icons[random.nextInt(icons.length)];
  }

  Color getRandomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppPaddingStyles.pagePadding,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final formattedDate =
            DateFormat('MMM d, yyyy').format(DateTime.parse(transaction.date));
        final randomIcon = getRandomIcon();
        final randomColor = getRandomColor();

        return TransactionItem(
          disableButton: disableButton,
          transaction: transaction,
          formattedDate: formattedDate,
          randomIcon: randomIcon,
          randomColor: randomColor,
        );
      },
    );
  }
}
