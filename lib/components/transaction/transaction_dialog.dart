import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';
import 'package:tymesavingfrontend/components/transaction/infor_row.dart';

class TransactionDialog extends StatelessWidget {
  final Transaction transaction;
  final String formattedDate;

  const TransactionDialog({
    super.key,
    required this.transaction,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(transaction.category),
          content: Container(
            width: constraints.maxWidth * 0.8, // 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  icon: Icons.label,
                  iconColor: Colors.blue,
                  label: 'Type:',
                  value: transaction.type,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.category,
                  iconColor: Colors.green,
                  label: 'Category:',
                  value: transaction.category,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.date_range,
                  iconColor: Colors.orange,
                  label: 'Date:',
                  value: formattedDate,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.attach_money,
                  iconColor: Colors.red,
                  label: 'Amount:',
                  value: '\$${transaction.amount.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your edit functionality here
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your delete functionality here
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
