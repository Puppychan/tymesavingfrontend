import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/transaction_type_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_sort_filter.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ViewAllTransactionsPage extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;

  const ViewAllTransactionsPage({super.key, required this.transactions});

  @override
  State<ViewAllTransactionsPage> createState() =>
      _ViewAllTransactionsPageState();
}

class _ViewAllTransactionsPageState extends State<ViewAllTransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortOrder = 'newest';
  List<Transaction>? _transactions = [];

  void _fetchTransactions() {
    Future.microtask(() async {
      if (!mounted) return;
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      final user = Provider.of<AuthService>(context, listen: false).user;
      await handleMainPageApi(context, () async {
        // handle tab selection
        if (_tabController.index == 0) {
          transactionService.setOptions(
              "filter", "getTransactionType", TransactionType.all.toString());
        } else if (_tabController.index == 1) {
          transactionService.setOptions("filter", "getTransactionType",
              TransactionType.income.toString());
        } else if (_tabController.index == 2) {
          transactionService.setOptions("filter", "getTransactionType",
              TransactionType.expense.toString());
        }
        // Fetch transactions from the backend
        return await transactionService.fetchTransactions(user!.id);
      }, () async {
        final filteredTransactions =
            transactionService.transactions?.values.expand((element) => element).toList();
        setState(() {
          _transactions = filteredTransactions;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchTransactions();
  }

  // @override
  // void didChangeDependencies() {
  //   // Fetch invitations when the page is loaded
  //   super.didChangeDependencies();
  //   _fetchTransactions();
  // }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(String type) {
    List<Transaction> filteredTransactions = widget.transactions.values
        .expand((list) => list)
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

  // void _onSortOrderChanged(String? newValue) {
  //   if (newValue != null) {
  //     setState(() {
  //       _sortOrder = newValue;
  //     });
  //   }
  // }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    _fetchTransactions(); // Fetch invitations when tab changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(
        title: 'All Transactions',
        bottom: TabBar(
          controller: _tabController,
          tabs: TransactionType.list.map((val) => Tab(text: val)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () {
              showStyledBottomSheet(
                context: context,
                contentWidget: TransactionSortFilter(
                    updateTransactionList: _fetchTransactions),
              );
            },
          ),
          // DropdownButton<String>(
          //   value: _sortOrder,
          //   // icon: const Icon(Icons.more_vert),
          //   onChanged: _onSortOrderChanged,
          //   items: <String>['ascending', 'descending', 'newest', 'oldest']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value.capitalize()),
          //     );
          //   }).toList(),
          //   underline: const SizedBox(), // Remove underline
          // ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: TransactionType.list
            .map((_) => TransactionList(transactions: _transactions!))
            .toList(),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
