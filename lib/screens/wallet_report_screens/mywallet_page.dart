import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/mywallet_page/mywallet_transaction.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class MywalletPage extends StatefulWidget {
  const MywalletPage({super.key});

  @override
  State<MywalletPage> createState() => _MywalletPageState();
}

class _MywalletPageState extends State<MywalletPage> {
  late ChartReport chartReport;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getChartReport();
        // return result;
      }, () async {
        setState(() {
          // Create the transaction
          chartReport = transactionService.chartReport!;
          debugPrint(chartReport.totals.toString());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: 'Wallet',
        showBackButton: true,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        CustomLineChart(
          totals: chartReport.totals,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Transaction',
          style: AppTextStyles.headingMedium,
        ),
        const Expanded(
          child: MyWalletTransaction(),
        ),
      ]),
      backgroundColor: AppColors.cream,
    );
  }
}
