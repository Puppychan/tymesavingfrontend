import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/chart/report_pie_chart_categories.dart';
import 'package:tymesavingfrontend/components/common/chart/report_pie_chart_user.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_list.dart';
import 'package:tymesavingfrontend/models/report_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupSavingReport extends StatefulWidget {
  const GroupSavingReport({super.key, required this.groupSavingId});

  final String groupSavingId;

  @override
  State<GroupSavingReport> createState() => _GroupSavingReportState();
}

class _GroupSavingReportState extends State<GroupSavingReport> {
  List<ReportUser> _userList = [];
    List<ReportCategory> _categoryList = [];
    List<Transaction> _transactionList = [];
    ReportInfo? _reportInfo;
    String filter = "latest";
    bool isLoading = true;
    bool displayGraph = true;

    Future<void> _fetchReportData(String? userId) async {
      Future.microtask(() async {
        if (!mounted) return;
        final savingService = Provider.of<GroupSavingService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await savingService.fetchSavingReport(widget.groupSavingId, filter);
        }, () async {
          if (!mounted) return;
          setState(() {
            _userList = savingService.reportUserList;
            _categoryList = savingService.reportCategoryList;
            _transactionList = savingService.transactions;
            _reportInfo = savingService.reportInfo;
            isLoading = false;
            // Check if no transaction
            if (_reportInfo!.concurrentAmount == 0){
              displayGraph = false;
            }
          });
        });
      });
    }
    
  String formatDate(DateTime date){
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  @override
  void initState() {
    _fetchReportData(widget.groupSavingId);
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
            Text(
              "Final report of", 
              style: textTheme.headlineMedium,
              softWrap: true,
              overflow: TextOverflow.visible,
              ),
            Text(_reportInfo!.name,style: textTheme.headlineSmall),
            _reportInfo!.description != "" ?
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(_reportInfo!.description, 
                        style: textTheme.bodyMedium, 
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        ),
            )
            : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('This group currently have no description!', 
                        style: textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic), 
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Budget at the start', style: Theme.of(context).textTheme.bodyMedium,),
                      const Expanded(child: SizedBox()),
                      Text(formatAmountToVnd(_reportInfo!.amount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                    ],  
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Left over budget', style: Theme.of(context).textTheme.bodyMedium,),
                      const Expanded(child: SizedBox()),
                      Text(formatAmountToVnd(_reportInfo!.concurrentAmount), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Created on', style: Theme.of(context).textTheme.bodyMedium,),
                      const Expanded(child: SizedBox()),
                      Text(formatDate(_reportInfo!.createdDate), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('End on', style: Theme.of(context).textTheme.bodyMedium,),
                      const Expanded(child: SizedBox()),
                      Text(formatDate(_reportInfo!.endDate), style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
            displayGraph ? 
            Column(
              children: [
                Text("Top categories in group", style: textTheme.headlineMedium,),
                const SizedBox(height: 10,),
                ReportPieChartCategories(reportCategory: _categoryList),
                const SizedBox(height: 10,),
                Text("Top user on income contribution", style: textTheme.headlineMedium,),
                const SizedBox(height: 10,),
                ReportPieChartUser(reportUserList: _userList),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Top 10 transaction by", style: textTheme.headlineMedium!.copyWith(fontSize: 18),),
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
                          _fetchReportData(widget.groupSavingId);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TransactionList(transactions: _transactionList,disableButton: true,)
                )
              ],
            )
            : Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text('No transaction for data to be displayed', style: textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),),
            )
          ],
        ),
      ),
    );
  }
}