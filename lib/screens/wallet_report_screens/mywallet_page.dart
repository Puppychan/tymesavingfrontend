import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/mywallet_page/mywallet_transaction.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class MywalletPage extends StatefulWidget {
  const MywalletPage({super.key});

  @override
  State<MywalletPage> createState() => _MywalletPageState();
}

class _MywalletPageState extends State<MywalletPage> {
  ChartReport? chartReport;

  @override
  void initState() {
    super.initState();
    User? user;
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        setState(() {
          user = authService.user;
        });
      });
    });

    Future.microtask(() async {
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getChartReport(user);
        // return result;
      }, () async {
        setState(() {
          // Create the transaction
          chartReport = transactionService.chartReport;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Heading(
        title: 'Wallet',
        showBackButton: true,
      ),
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        CustomLineChart(
              
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Transaction',
          style: AppTextStyles.headingMedium,
        ),
        Expanded(
          child: MyWalletTransaction(),
        ),
      ]),
      backgroundColor: AppColors.cream,
    );
  }
}
