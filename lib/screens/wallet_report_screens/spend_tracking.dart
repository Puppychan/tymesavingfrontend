import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/mywallet_page/expense_card.dart';
import 'package:tymesavingfrontend/components/mywallet_page/income_card.dart';
import 'package:tymesavingfrontend/components/mywallet_page/tip_card.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class SpendTracking extends StatefulWidget {
  const SpendTracking({super.key});

  @override
  State<SpendTracking> createState() => _SpendTrackingState();
}

class _SpendTrackingState extends State<SpendTracking> {
  ChartReport? chartReport;
  CurrentMonthReport? currentMonthReport;
  NetSpend? netSpend;

  @override
  void initState() {
    User? user;
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        setState(() {
          user = authService.user;
        });
      });

      if (!mounted) return;
      // Start the second task only after the first one completes
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getChartReport(user?.id);
      }, () async {
        setState(() {
          chartReport = transactionService.chartReport!;
          currentMonthReport = transactionService.currrentMonthReport;
          netSpend = transactionService.netSpend;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const Heading(
        title: 'Tracking',
        showBackButton: true,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          'Spending trend (past 12 month)',
          style: textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        Skeletonizer(
          enabled: chartReport == null,
          child: CustomLineChart(
            totals: chartReport?.totals ??
                {'JAN': 0, 'FEB': 0, 'MAR': 0, 'APR': 0, 'MAY': 0, 'JUN': 0},
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (currentMonthReport == null)
          // Display a loading indicator or placeholder widget
          const CircularProgressIndicator(),
          Skeletonizer(
            enabled: chartReport == null,
            child: ExpenseCard(
                month: currentMonthReport?.currentMonth ?? '',
                expense: currentMonthReport?.totalAmount ?? 0),
          ),
          Skeletonizer(
            enabled: chartReport == null,
            child: IncomeCard(currentMonthIncome: netSpend?.currentMonthIncome ?? 0, currentNetSpend: netSpend?.currentNetSpend ?? 0)
          ),
          Skeletonizer(
            enabled: chartReport == null,
            child: TipCard(netSpend: netSpend?.currentNetSpend ?? 0)
          ),
      ]),
    );
  }
}
