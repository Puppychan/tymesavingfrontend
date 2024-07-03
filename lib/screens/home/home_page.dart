import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_section.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
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

  Future<void> _loadData() async {
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
      await handleMainPageApi(context, () async {
        return await transactionService.fetchTransactions(widget.user!.id);
      }, () async {
        setState(() {
          transactions = transactionService.transactions;
        });
      });
    }

    setState(() {
      isLoading = false;
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

  // @override
  // void didPopNext() {
  //   // Called when the current route has been popped off, and the current route shows up.
  //   Future.microtask(() async {
  //     if (mounted) {
  //       final authService = Provider.of<AuthService>(context, listen: false);
  //       await handleMainPageApi(context, () async {
  //         return await authService.getCurrentUserData();
  //         // return result;
  //       }, () async {
  //         setState(() {
  //           widget.user = authService.user;
  //         });
  //       });
  //     }
  //   });
  // }

  void _navigateToAllTransactions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewAllTransactionsPage(transactions: transactions!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            CustomBarChart(
              totalsExpense: chartReport!.totals,
              totalsIncome: chartReportSecondary!.totals,
            ),

          const SizedBox(height: 12), // Add some spacing between sections
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // This aligns the children with space between them
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
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Add some spacing between sections
          SizedBox(
            height: 500,
            child: TransactionSection(transactions: transactions!),
          ),
        ],
      ),
    );
  }
}
