import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';

class MonthTab extends StatelessWidget {
  final String month;
  final List<Transaction>? transactions;

  const MonthTab({super.key, required this.month, this.transactions});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: SizedBox(
        width: 60,
        child: Center(
          child: Text(month),
        ),
      ),
    );
  }
}
