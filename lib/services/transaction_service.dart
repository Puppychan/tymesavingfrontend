import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction.model.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class TransactionService extends ChangeNotifier {
  // Create a private transaction report variable to store report received
  ChartReport? _chartReport;
  ChartReport? _chartReportSecondary;
  CompareToLastMonth? _compareToLastMonth;
  CurrentMonthReport? _currentMonthReport;
  TopCategoriesList? _topCategoriesList;
  NetSpend? _netSpend;

  // Getter to access outside of this class
  CompareToLastMonth? get compareToLastMonth => _compareToLastMonth;
  ChartReport? get chartReport => _chartReport;
  ChartReport? get chartReportSecondary => _chartReportSecondary;
  CurrentMonthReport? get currrentMonthReport => _currentMonthReport;
  TopCategoriesList? get topCategoriesList => _topCategoriesList;
  NetSpend? get netSpend => _netSpend;

  Future<Map<String, dynamic>> getChartReport(userid) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    final responseData = response['response'];

    // debugPrint("Debuging check for getChartReport $responseData");

    notifyListeners();
    _chartReport = ChartReport.fromJson(responseData);
    _currentMonthReport =
        CurrentMonthReport.fromJson(responseData['currentMonthTotal']);
    _netSpend = NetSpend.fromJson(responseData['netSpend']);
    return response;
  }

  Future<Map<String, dynamic>> getBothChartReport(userid) async {
    print("getBothChartReport ${userid}");
    final expenseResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    print("getBothChartReport after expenseResponse");
    final incomeResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Income&userId=$userid");
    print("getBothChartReport after incomeResponse");
    final responseDataExpense = expenseResponse['response'];
    print("getBothChartReport after responseDataExpense");
    final responseDataIncome = incomeResponse['response'];
    print("getBothChartReport after responseDataIncome");
    notifyListeners();
    _chartReport = ChartReport.fromJson(responseDataExpense);
    print("getBothChartReport after _chartReport");
    _chartReportSecondary = ChartReport.fromJson(responseDataIncome);
    print("getBothChartReport after _chartReportSecondary");
    return expenseResponse;
  }

  Future<Map<String, dynamic>> getReportDetail(userid) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    if (response['response'] != null &&
        response['response']['compareToLastMonth'] != null &&
        response['response']['topCategories'] != null) {
      final responseData = response['response']['compareToLastMonth'];
      final responseCategoryData = response['response']['topCategories'];
      // Type checking, since percentages is String but current is int
      // debugPrint(responseData['currentIncome'].runtimeType.toString());
      // debugPrint(responseData['incomePercentage'].runtimeType.toString());
      // debugPrint(responseData['currentExpense'].runtimeType.toString());
      // debugPrint(responseData['expensePercentage'].runtimeType.toString());

      _compareToLastMonth = CompareToLastMonth.fromJson(responseData);
      _topCategoriesList = TopCategoriesList.fromJson(responseCategoryData);
      notifyListeners();
    } else {
      final responseData = response['response']['compareToLastMonth'];
      _compareToLastMonth = CompareToLastMonth.fromJson(responseData);
      _topCategoriesList = null;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, List<Transaction>>> fetchTransactions(userid) async {
    // "https://tyme-saving-backend.vercel.app/api/transaction/byUser/72e4b93000be75dd6e367723"
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReportByUser}/$userid");


    if (response['response'] != null &&
        response['statusCode'] == 200) {
      // final data = json.decode(response.body);
      // print('Raw JSON response: $data');

      // final responseData = data['response'] as Map<String, dynamic>;
      // print('Parsed response data: $responseData');

      // return responseData.map((month, transactions) {
      //   final transactionList = (transactions['transactions'] as List<dynamic>)
      //       .map((transaction) => Transaction.fromJson(transaction))
      //       .toList();

      //   print('Transactions for $month: $transactionList');
        
      // });
      return response['response'];
    } else {
      print('Failed to load transactions. Status code: ${response.statusCode}');
      throw Exception('Failed to load transactions');
    }
  }
}
