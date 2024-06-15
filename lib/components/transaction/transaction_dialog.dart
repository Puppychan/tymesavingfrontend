import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';

class TransactionDialog extends StatelessWidget {
  final Transaction transaction;
  final String formattedDate;

  TransactionDialog({required this.transaction, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(transaction.category),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${transaction.type}'),
          Text('Category: ${transaction.category}'),
          Text('Date: $formattedDate'),
          Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
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
  }
}
