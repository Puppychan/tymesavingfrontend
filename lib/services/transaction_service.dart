import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class TransactionService extends ChangeNotifier {
  // Create a private transaction report variable to store report received
  ChartReport? _chartReport;
  CompareToLastMonth? _compareToLastMonth;

  // Getter to access outside of this class
  CompareToLastMonth? get compareToLastMonth => _compareToLastMonth;
  ChartReport? get chartReport => _chartReport;

  Future<Map<String, dynamic>> getChartReport() async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=2eff0eddee0b8c9a2601fead");
    final responseData = response['response'] as Map<String, dynamic>;

    debugPrint("Debuging check for getChartReport $responseData");

    notifyListeners();
    _chartReport = ChartReport.fromJson(responseData);
    return response;
  }

  Future<Map<String, dynamic>> getLastMonth(user) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=${user?.id}");
    debugPrint(user?.id);
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
