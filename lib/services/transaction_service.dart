import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class TransactionService extends ChangeNotifier {
  // Create a private transaction report variable to store report received
  ChartReport? _chartReport;
  ChartReport? _chartReportSecondary;
  CompareToLastMonth? _compareToLastMonth;
  CurrentMonthReport? _currentMonthReport;

  // Getter to access outside of this class
  CompareToLastMonth? get compareToLastMonth => _compareToLastMonth;
  ChartReport? get chartReport => _chartReport;
  ChartReport? get chartReportSecondary => _chartReportSecondary;
  CurrentMonthReport? get currrentMonthReport => _currentMonthReport;

  Future<Map<String, dynamic>> getChartReport(userid) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    final responseData = response['response'] as Map<String, dynamic>;

    // debugPrint("Debuging check for getChartReport $responseData");

    notifyListeners();
    _chartReport = ChartReport.fromJson(responseData);
    _currentMonthReport =
        CurrentMonthReport.fromJson(responseData['currentMonthTotal']);
    return response;
  }

  Future<Map<String, dynamic>> getBothChartReport(userid) async {
    final expenseResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    final incomeResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Income&userId=$userid");
    final responseDataExpense =
        expenseResponse['response'] as Map<String, dynamic>;
    final responseDataIncome =
        incomeResponse['response'] as Map<String, dynamic>;
    notifyListeners();
    _chartReport = ChartReport.fromJson(responseDataExpense);
    _chartReportSecondary = ChartReport.fromJson(responseDataIncome);
    return expenseResponse;
  }

  Future<Map<String, dynamic>> getLastMonth(userid) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    if (response['response'] != null &&
        response['response']['compareToLastMonth'] != null) {
      final responseData =
          response['response']['compareToLastMonth'] as Map<String, dynamic>;

      // Type checking, since percentages is String but current is int
      // debugPrint(responseData['currentIncome'].runtimeType.toString());
      // debugPrint(responseData['incomePercentage'].runtimeType.toString());
      // debugPrint(responseData['currentExpense'].runtimeType.toString());
      // debugPrint(responseData['expensePercentage'].runtimeType.toString());

      _compareToLastMonth = CompareToLastMonth.fromJson(responseData);
      notifyListeners();
    } else {
      debugPrint('Invalid response structure');
    }
    return response;
  }
}
