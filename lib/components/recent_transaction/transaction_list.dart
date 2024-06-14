import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.category),
          subtitle: Text(transaction.createdDate.toLocal().toString()),
          trailing: Text('\$${transaction.amount.toString()}'),
        );
      },
    );
  }
}
