import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:tymesavingfrontend/models/transaction.model.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList({required this.transactions});

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
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final formattedDate =
            DateFormat('MMM d, yyyy').format(DateTime.parse(transaction.date));
        final randomIcon = getRandomIcon();
        final randomColor = getRandomColor();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundColor: randomColor,
              child: Icon(
                randomIcon,
                color: Colors.white,
              ),
            ),
            title: Text(transaction.category,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  transaction.type,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 3),
                Text(formattedDate,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat')),
              ],
            ),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat'),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(transaction.category),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${transaction.type}'),
                        Text('Category: ${transaction.category}'),
                        Text('Date: $formattedDate'),
                        Text(
                            'Amount: \$${transaction.amount.toStringAsFixed(2)}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add your edit functionality here
                        },
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add your delete functionality here
                        },
                        child: Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
