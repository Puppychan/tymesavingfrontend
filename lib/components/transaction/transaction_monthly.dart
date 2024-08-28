import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart'; // Add this import

class TransactionMonthlyTabBar extends StatefulWidget {
  final String userId;

  const TransactionMonthlyTabBar({super.key, required this.userId});

  @override
  _TransactionMonthlyTabBarState createState() =>
      _TransactionMonthlyTabBarState();
}

class _TransactionMonthlyTabBarState extends State<TransactionMonthlyTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late int currentYear;
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
  List<Transaction>? transactions; // To store the fetched transactions
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();

    // Initialize with the current year and current month index
    currentYear = DateTime.now().year;
    int currentMonthIndex = DateTime.now().month - 1;

    // Initialize the TabController with the current month index
    _tabController = TabController(
      length: months.length,
      vsync: this,
      initialIndex: currentMonthIndex,
    );

    // Add a listener to the TabController to detect tab changes
    _tabController?.addListener(() {
      if (!_tabController!.indexIsChanging) {
        _fetchTransactionsForSelectedMonth();
      }
    });

    // Initial data load
    _fetchTransactionsForSelectedMonth();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Method to fetch transactions based on the selected month and year
  Future<void> _fetchTransactionsForSelectedMonth() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    final transactionService =
        Provider.of<TransactionService>(context, listen: false);

    int selectedMonth = _tabController?.index ?? 0;

    final fetchedTransactions =
        await transactionService.fetchTransactionsByMonthAndYear(
      widget.userId,
      currentYear,
      selectedMonth + 1,
    );

    setState(() {
      transactions =
          fetchedTransactions.isNotEmpty ? fetchedTransactions : null;
      isLoading = false; // Hide loading indicator
    });
  }

  // Method to change the year when navigating through year controls
  void _changeYear(int delta) {
    setState(() {
      currentYear += delta;
    });

    // Fetch transactions for the new year with the currently selected month
    _fetchTransactionsForSelectedMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () => _changeYear(-1),
                  ),
                  Text(
                    '$currentYear',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () => _changeYear(1),
                  ),
                ],
              ),
              TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 2.0,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                labelPadding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
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
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: months.map((month) {
                return transactions != null
                    ? RefreshIndicator(onRefresh: () async {
                      setState(() {
                        isLoading = true;
                      });
                      _fetchTransactionsForSelectedMonth();
                    },
                    child: TransactionList(transactions: transactions!))
                    : const NotFoundMessage(message: 'No transactions found');
              }).toList(),
            ),
    );
  }
}
