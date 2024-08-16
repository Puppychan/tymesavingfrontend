import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/components/transaction/infor_row.dart';
import 'package:tymesavingfrontend/screens/transaction/transaction_update_page.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

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
          title: Text(transaction.category,
              style: Theme.of(context).textTheme.headlineMedium),
          content: SizedBox(
            width: constraints.maxWidth * 0.8, // 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  icon: Icons.label,
                  iconColor: Colors.indigo[600],
                  label: 'Type:',
                  value: transaction.type,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.category,
                  iconColor: Colors.green[800],
                  label: 'Category:',
                  value: transaction.category,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.date_range,
                  iconColor: Colors.orange[800],
                  label: 'Date:',
                  value: formattedDate,
                ),
                const SizedBox(height: 8),
                InfoRow(
                  icon: Icons.attach_money,
                  iconColor: Colors.red[800],
                  label: 'Amount:',
                  value: formatAmountToVnd(transaction.amount),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  transaction.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionUpdatePage(
                                  transactionId: transaction.id,
                                )));
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
            ),
          ],
        );
      },
    );
  }
}
