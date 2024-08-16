import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/chart/report_pie_chart_categories.dart';
import 'package:tymesavingfrontend/components/common/chart/report_pie_chart_user.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/models/report_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetReport extends StatefulWidget {
  const BudgetReport({super.key, required this.budgetId});

  final String budgetId;

  @override
  State<BudgetReport> createState() => _BudgetReportState();
}

class _BudgetReportState extends State<BudgetReport> {
  List<ReportUser> _userList = [];
    List<ReportCategory> _categoryList = [];
    List<Transaction> _transactionList = [];
    String filter = "latest";
    bool isLoading = true;

    Future<void> _fetchReportData(String? userId) async {
      Future.microtask(() async {
        if (!mounted) return;
        final budgetService = Provider.of<BudgetService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await budgetService.fetchBudgetReport(widget.budgetId, filter);
        }, () async {
          if (!mounted) return;
          setState(() {
            _userList = budgetService.reportUserList;
            _categoryList = budgetService.reportCategoryList;
            _transactionList = budgetService.transactions;
            isLoading = false;
          });
        });
      });
    }

  @override
  void initState() {
    _fetchReportData(widget.budgetId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const Heading(
        title: "End Report",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: isLoading ?
        const Center(child: CircularProgressIndicator() )
        : Column(
          children: [
            Text("Top categories in group", style: textTheme.headlineMedium,),
            const SizedBox(height: 10,),
            ReportPieChartCategories(reportCategory: _categoryList),
            const SizedBox(height: 10,),
            Text("Top user on expense", style: textTheme.headlineMedium,),
            const SizedBox(height: 10,),
            ReportPieChartUser(reportUserList: _userList),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Top transaction by", style: textTheme.headlineMedium!.copyWith(fontSize: 18),),
                const SizedBox(width: 5,),
                DropdownButton<String>(
                  value: filter,
                  items: [
                    DropdownMenuItem(
                      value: 'latest',
                      child: Text('Most recent', style: textTheme.bodySmall,),
                    ),
                    DropdownMenuItem(
                      value: 'earliest',
                      child: Text('Oldest', style: textTheme.bodySmall,),
                    ),
                    DropdownMenuItem(
                      value: 'highest',
                      child: Text('Highest value', style: textTheme.bodySmall,),
                    ),
                    DropdownMenuItem(
                      value: 'lowest',
                      child: Text('Lowest value', style: textTheme.bodySmall,),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filter = value!;
                      _fetchReportData(widget.budgetId);
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 500,
              child: TransactionList(transactions: _transactionList,)
            )
            
          ],
        ),
      ),
    );
  }
}