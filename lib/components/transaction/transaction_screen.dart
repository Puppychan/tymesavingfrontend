import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';

class TransactionScreen extends StatelessWidget {
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

  final Map<String, List<Transaction>> transactions = {
    'Jan': [
      Transaction(
          id: '666a4e3b82c9937c9073834e',
          type: 'Income',
          category: 'Rental Income',
          amount: 1750000,
          date: '2024-01-11T05:23:21.000Z'),
      Transaction(
          id: '666a4e3b82c9937c90738306',
          type: 'Income',
          category: 'Investment Income',
          amount: 1565000,
          date: '2024-01-03T03:28:17.000Z'),
    ],
    'Feb': [
      Transaction(
          id: '666a4e3b82c9937c907382c0',
          type: 'Income',
          category: 'Rental Income',
          amount: 9203000,
          date: '2024-02-02T08:47:53.000Z'),
    ],
    'Mar': [
      Transaction(
          id: '666a4e3b82c9937c907382b4',
          type: 'Income',
          category: 'Business Profits',
          amount: 9947000,
          date: '2024-03-15T18:22:02.000Z'),
      Transaction(
          id: '666a4e3b82c9937c90738294',
          type: 'Expense',
          category: 'Groceries',
          amount: 4162000,
          date: '2024-03-14T08:11:21.000Z'),
      Transaction(
          id: '666a4e3b82c9937c90738315',
          type: 'Income',
          category: 'Freelance Work',
          amount: 4568000,
          date: '2024-03-12T22:59:57.000Z'),
      Transaction(
          id: '666a4e3b82c9937c907382a8',
          type: 'Income',
          category: 'Salary',
          amount: 1545000,
          date: '2024-03-09T01:34:47.000Z'),
      Transaction(
          id: '666a4e3b82c9937c90738383',
          type: 'Income',
          category: 'Freelance Work',
          amount: 9851000,
          date: '2024-03-08T12:59:45.000Z'),
    ],
    'Apr': [
      Transaction(
          id: '666a4e3b82c9937c907383f8',
          type: 'Expense',
          category: 'Transportation',
          amount: 3108000,
          date: '2024-04-07T19:26:00.000Z'),
      Transaction(
          id: '666a4e3b82c9937c907383d7',
          type: 'Income',
          category: 'Rental Income',
          amount: 4949000,
          date: '2024-04-03T00:27:57.000Z'),
      Transaction(
          id: '666a4e3b82c9937c907382b0',
          type: 'Expense',
          category: 'Transportation',
          amount: 2426000,
          date: '2024-04-02T20:59:07.000Z'),
    ],
    'May': [
      Transaction(
          id: '666a4e3b82c9937c90738297',
          type: 'Income',
          category: 'Investment Income',
          amount: 6353000,
          date: '2024-05-16T05:28:02.000Z'),
    ],
    'Jun': [
      Transaction(
          id: '666a4e3b82c9937c90738338',
          type: 'Income',
          category: 'Salary',
          amount: 78000,
          date: '2024-06-06T16:13:24.000Z'),
    ],
  };

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
                return TransactionList(transactions: transactions[month] ?? []);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
