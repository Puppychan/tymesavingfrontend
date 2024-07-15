import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';

class ViewAllTransactionsPage extends StatefulWidget {
  final dynamic
      transactions; // Can be List<Transaction> or Map<String, List<Transaction>>

  const ViewAllTransactionsPage({super.key, required this.transactions});

  @override
  _ViewAllTransactionsPageState createState() =>
      _ViewAllTransactionsPageState();
}

class _ViewAllTransactionsPageState extends State<ViewAllTransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortOrder = 'newest';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(String type) {
    List<Transaction> allTransactions;

    if (widget.transactions is List<Transaction>) {
      allTransactions = widget.transactions;
    } else if (widget.transactions is Map<String, List<Transaction>>) {
      allTransactions = (widget.transactions as Map<String, List<Transaction>>)
          .values
          .expand((list) => list)
          .toList();
    } else {
      return [];
    }

    List<Transaction> filteredTransactions = allTransactions
        .where((transaction) => transaction.type == type)
        .toList();

    switch (_sortOrder) {
      case 'ascending':
        filteredTransactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case 'descending':
        filteredTransactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'newest':
        filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest':
        filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    return filteredTransactions;
  }

  void _onSortOrderChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _sortOrder = newValue;
      });
    }
  }

  Widget _buildNoTransactionsMessage() {
    return Center(
      child: Text(
        'No transactions available.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(
        title: 'All Transactions',
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOrder,
            onChanged: _onSortOrderChanged,
            items: <String>['ascending', 'descending', 'newest', 'oldest']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.capitalize()),
              );
            }).toList(),
            underline: const SizedBox(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _filterTransactions('Income').isEmpty
              ? _buildNoTransactionsMessage()
              : TransactionList(transactions: _filterTransactions('Income')),
          _filterTransactions('Expense').isEmpty
              ? _buildNoTransactionsMessage()
              : TransactionList(transactions: _filterTransactions('Expense')),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
