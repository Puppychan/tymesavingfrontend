import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_monthly.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_section.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/tracking_report/spend_tracking.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_warning.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/screens/transaction/view_all_transaction_page.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  ChartReport? chartReport;
  ChartReport? chartReportSecondary;
  Map<String, List<Transaction>>? transactions;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _loadData() async {
    Future.microtask(() async {
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);

      if (widget.user != null) {
        await handleMainPageApi(context, () async {
          return await transactionService.getBothChartReport(widget.user!.id);
        }, () async {
          setState(() {
            chartReport = transactionService.chartReport;
            chartReportSecondary = transactionService.chartReportSecondary;
          });
        });

        if (!mounted) return;
        // await handleMainPageApi(context, () async {
        //   return await transactionService.fetchTransactions(widget.user!.id);
        // }, () async {
        //   setState(() {
        //     transactions = transactionService.transactions;
        //   });
        // });
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _loadData();
    super.didPopNext();
  }

  void _navigateToAllTransactions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewAllTransactionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: AppPaddingStyles.pagePaddingIncludeSubText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset("assets/img/app_logo_light.svg",
          //     width: media.width * 0.5, fit: BoxFit.contain),
          CustomAlignText(
            text: 'Have a nice day!',
            style: Theme.of(context).textTheme.headlineMedium!,
          ),
          const SizedBox(
            height: 10,
          ),
          if (chartReport == null && chartReportSecondary == null)
            Column(
              children: [
                const SizedBox(height: 16),
                Text("No data available for chart",
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 16),
              ],
            )
          else
            Container(
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.secondary,
                    spreadRadius: 0.1,
                    blurRadius: 4,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SpendTracking()));
                },
                child: CustomBarChart(
                  totalsExpense: chartReport!.totals,
                  totalsIncome: chartReportSecondary!.totals,
                ),
              ),
            ),
          const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Text(
                  "Graph tips:",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                Text(
                  "Color ",
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Container(
                  width: 10,  // Width of the color box
                  height: 10, // Height of the color box
                  color: Theme.of(context).colorScheme.inversePrimary, // Color of the box
                  margin: const EdgeInsets.only(right: 4), // Space between the box and the text
                ),
                Text(
                  ' indicate total expense/month',
                  style: Theme.of(context).textTheme.bodyMedium, // Customize your text style
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                Text(
                  "Color ",
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Container(
                  width: 10,  // Width of the color box
                  height: 10, // Height of the color box
                  color: Theme.of(context).colorScheme.primary, // Color of the box
                  margin: const EdgeInsets.only(right: 4), // Space between the box and the text
                ),
                Text(
                  ' indicate total income/month',
                  style: Theme.of(context).textTheme.bodyMedium, // Customize your text style
                ),
              ],
            ),
          const SizedBox(height: 12), // Add some spacing between sections
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Transactions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  if (transactions == null) {
                    WarningDisplay.showWarningToast(
                        "No transactions available", context);
                  }
                  _navigateToAllTransactions(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.tertiary),
                  child: Text('View detail',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            // child: TransactionSection(transactions: transactions ?? {}),
            child: TransactionMonthlyTabBar(userId: widget.user!.id),
          ),
        ],
      ),
    );
  }
}
