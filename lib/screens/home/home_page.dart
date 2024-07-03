import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_section.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/screens/transaction/view_all_transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late User? user; // Assuming User is a defined model
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
    final authService = Provider.of<AuthService>(context, listen: false);
    final transactionService =
        Provider.of<TransactionService>(context, listen: false);

    await handleMainPageApi(context, () async {
      return await authService.getCurrentUserData();
    }, () async {
      setState(() {
        user = authService.user;
      });
    });

    if (user != null) {
      await handleMainPageApi(context, () async {
        return await transactionService.getBothChartReport(user!.id);
      }, () async {
        setState(() {
          chartReport = transactionService.chartReport;
          chartReportSecondary = transactionService.chartReportSecondary;
        });
      });

      await handleMainPageApi(context, () async {
        return await transactionService.fetchTransactions(user!.id);
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

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up.
    Future.microtask(() async {
      if (mounted) {
        final authService = Provider.of<AuthService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await authService.getCurrentUserData();
          // return result;
        }, () async {
          setState(() {
            user = authService.user;
          });
        });
      }
    });
  }

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
            height: 24,
          ),
          CustomBarChart(
            totalsExpense: chartReport!.totals,
            totalsIncome: chartReportSecondary!.totals,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: transactions == null
                  ? null
                  : () => _navigateToAllTransactions(context),
              child: const Text('View All Transactions'),
            ),
          ),
          const SizedBox(height: 24), // Add some spacing between sections
          SizedBox(
            height: 500,
            child: TransactionSection(transactions: transactions!),
          ),
        ],
      ),
    );
  }
}
