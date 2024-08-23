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
import 'package:popover/popover.dart';

class ViewAllTransactionsPage extends StatefulWidget {
  const ViewAllTransactionsPage({super.key});

  @override
  State<ViewAllTransactionsPage> createState() =>
      _ViewAllTransactionsPageState();
}

class _ViewAllTransactionsPageState extends State<ViewAllTransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Transaction>? _transactions = [];
  String _sortOption = 'sortDateCreated'; // Default sort option
  String _sortOrder = 'ascending'; // Default sort order

  void _fetchTransactions() async {
    final transactionService =
        Provider.of<TransactionService>(context, listen: false);
    final user = Provider.of<AuthService>(context, listen: false).user;

    String tab = TransactionType.list[_tabController.index];
    List<Transaction> transactions =
        await transactionService.fetchTransactionsSortHandler(
      tab: tab,
      sortOption: _sortOption,
      sortOrder: _sortOrder,
      userId: user!.id,
    );

    setState(() {
      _transactions = transactions;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    _fetchTransactions(); // Fetch transactions when tab changes
  }

  void _handleSortOptionSelection(String result) {
    switch (result) {
      case 'newest':
        _sortOption = 'sortDateCreated';
        _sortOrder = 'descending';
        break;
      case 'oldest':
        _sortOption = 'sortDateCreated';
        _sortOrder = 'ascending';
        break;
      case 'ascending':
        _sortOption = 'sortAmount';
        _sortOrder = 'ascending';
        break;
      case 'descending':
        _sortOption = 'sortAmount';
        _sortOrder = 'descending';
        break;
    }
    _fetchTransactions(); // Refresh transactions after selection
  }

  Widget _buildNoTransactionsMessage() {
    return const Center(
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
          tabs: TransactionType.list.map((val) => Tab(text: val)).toList(),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert), // Using the more vertical icon
              onPressed: () {
                showPopover(
                  context: context,
                  bodyBuilder: (context) => ListItems(
                    onItemSelected: (String result) {
                      _handleSortOptionSelection(result);
                    },
                  ),
                  onPop: () => print('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  width: 200,
                  height: 220,
                  arrowHeight: 10,
                  arrowWidth: 15,
                );
              },
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: TransactionType.list
            .map((_) => _transactions == null || _transactions!.isEmpty
                ? _buildNoTransactionsMessage()
                : TransactionList(transactions: _transactions!))
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

class ListItems extends StatelessWidget {
  final Function(String) onItemSelected;

  const ListItems({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.tertiary,
            title: const Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 10,
                ),
                Text("Newest")
              ],
            ),
            onTap: () {
              onItemSelected('newest');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.tertiary,
            title: const Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 10,
                ),
                Text('Oldest'),
              ],
            ),
            onTap: () {
              onItemSelected('oldest');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.tertiary,
            title: const Row(
              children: [
                Icon(Icons.attach_money),
                SizedBox(
                  width: 10,
                ),
                Text('Ascending'),
              ],
            ),
            onTap: () {
              onItemSelected('ascending');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.tertiary,
            title: const Row(
              children: [
                Icon(Icons.attach_money),
                SizedBox(
                  width: 10,
                ),
                Text('Descending'),
              ],
            ),
            onTap: () {
              onItemSelected('descending');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
