import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';

class TransactionScreen extends StatelessWidget {
  final Map<String, List<Transaction>> transactions;

  TransactionScreen({super.key, required this.transactions});

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: months.length,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                // Will Fix Later
                bottom: BorderSide(
                  color: AppColors.divider,
                  width: 1.5,
                ),
              ),
            ),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 2.0,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              labelStyle: Theme.of(context).textTheme.labelLarge,
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
              tabs: months.map((month) {
                return SizedBox(
                  width: 85,
                  child: Tab(text: month),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: months.map((month) {
                if (transactions[month] == null) {
                  // if not found
                  return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text('No transactions found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ));
                } else {
                  return TransactionList(
                      transactions: transactions[month] ?? []);
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
