import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_pie_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/report_page/empty_case_outflow.dart';
import 'package:tymesavingfrontend/components/report_page/outflow_header.dart';
import 'package:tymesavingfrontend/components/report_page/report_detail.dart';
import 'package:tymesavingfrontend/components/report_page/report_flow.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  CompareToLastMonth? compareToLastMonth;
  TopCategoriesList? topCategoriesList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Future.microtask(() async {
          final authService = Provider.of<AuthService>(context, listen: false);
          User? user = authService.user;
          if (mounted) {
            final transactionService =
                Provider.of<TransactionService>(context, listen: false);
            await handleMainPageApi(context, () async {
              return await transactionService.getReportDetail(user?.id);
              // return result;
            }, () async {
              setState(() {
                // Compare to last month
                compareToLastMonth = transactionService.compareToLastMonth;
                topCategoriesList = transactionService.topCategoriesList;
                isLoading = false;
              });
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: 'Reports',
        showBackButton: true,
      ),
      body: Skeletonizer(
        enabled: isLoading, // Show skeleton if user is null
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            _loadData();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReportFlow(
                    inflowCurrent: compareToLastMonth?.currentIncome ?? 0,
                    inflowPercentage: compareToLastMonth?.incomePercentage ?? '0',
                    outflowCurrent: compareToLastMonth?.currentExpense ?? 0,
                    outflowPercentage:
                        compareToLastMonth?.expensePercentage ?? '0'),
                const SizedBox(
                  height: 20,
                ),
                const OutflowHeader(),
                if (topCategoriesList == null)
                  const EmptyCaseOutFlow()
                else
                  CustomPieChart(topCategories: topCategoriesList!.topCategory),
                const SizedBox(
                  height: 20,
                ),
                if (topCategoriesList == null)
                  const SizedBox()
                else
                  ReportDetail(topCategories: topCategoriesList!.topCategory),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
