import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/monthly_report/expense_card.dart';
import 'package:tymesavingfrontend/components/monthly_report/income_card.dart';
import 'package:tymesavingfrontend/components/monthly_report/netspend_card.dart';
import 'package:tymesavingfrontend/components/monthly_report/tip_card.dart';
import 'package:tymesavingfrontend/models/monthly_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class SpendTracking extends StatefulWidget {
  const SpendTracking({super.key});

  @override
  State<SpendTracking> createState() => _SpendTrackingState();
}

class _SpendTrackingState extends State<SpendTracking> {
  ChartReport? chartReportExpense;
  ChartReport? chartReportIncome;
  CurrentMonthReport? currentMonthReportIncome;
  CurrentMonthReport? currentMonthReportExpense;
  NetSpend? netSpend;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
        setState(() {
          user = authService.user;
      });
      await _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
      // Start the second task only after the first one completes
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getChartReport(user!.id);
      }, () async {
        setState(() {
          chartReportExpense = transactionService.chartReport!;
          chartReportIncome = transactionService.chartReportSecondary!;
          currentMonthReportIncome = transactionService.currentMonthReportIncome;
          currentMonthReportExpense = transactionService.currentMonthReportExpense;
          netSpend = transactionService.netSpend;
          isLoading = false;
        });
      });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const Heading(
        title: 'Tracking',
        showBackButton: true,
      ),
      body: isLoading ?
      const Center(child: CircularProgressIndicator(),) : 
      RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Past 6 months cashflow trend',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(
              height: 1.5,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Tips: Understanding your spending and earning trend can help you optimize your spending!',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Skeletonizer(
              enabled: isLoading,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: isLoading ? 
                null : 
                CustomLineChart(
                  totalsExpense: chartReportExpense!.totals,
                  totalsIncome: chartReportIncome!.totals,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Past 6 months income/expense',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            SizedBox(
              height: 450,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chartReportIncome!.totals.length - 6,
                itemBuilder: (context, index) {
                  int changedIndex = index + 6;
                  String month = chartReportIncome!.totals.keys.elementAt(changedIndex);
                  int income = chartReportIncome!.totals[month]!;
                  int expense = chartReportExpense!.totals[month]!;
              
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
                    child: ListTile(
                      title: Text(
                        month,
                        style: textTheme.labelLarge
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Income: ${formatAmountToVnd(income.toDouble())}',
                            style: textTheme.bodyMedium!.copyWith(color: Colors.green),
                          ),
                          Text(
                            'Expense: ${formatAmountToVnd(expense.toDouble())}',
                            style: textTheme.bodyMedium!.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ),
            Text(
              'This month net info',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            Skeletonizer(
                enabled: isLoading,
                child: IncomeCard(
                    currentMonthIncome: netSpend?.currentMonthIncome ?? 0,
                    currentMonth: currentMonthReportIncome!.currentMonth)),
            Skeletonizer(
              enabled: isLoading,
              child: ExpenseCard(
                  month: currentMonthReportIncome?.currentMonth ?? '',
                  expense: currentMonthReportExpense?.totalAmount ?? 0),
            ),
            Skeletonizer(
                enabled: isLoading,
                child: NetSpendCard(netSpend: netSpend?.currentNetSpend ?? 0)),
            const SizedBox(height: 10),
            Skeletonizer(
                enabled: isLoading,
                child: TipCard(
                  netSpend: netSpend?.currentNetSpend ?? 0,
                  income: netSpend!.currentMonthIncome,
                  expense: netSpend!.currentMonthExpense,
                  )),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
