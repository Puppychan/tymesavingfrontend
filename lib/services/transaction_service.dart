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

  Future<ChartReport> getChartReport(user) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=${user?.id}");
      final responseData = response['response'] as Map<String, dynamic>;
      // _transactionReport = TransactionReport.fromJson(responseData);
      notifyListeners();
      _chartReport = ChartReport.fromJson(responseData);
    return response;
  }

  Future<CompareToLastMonth> getLastMonth(user) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=${user?.id}");
      debugPrint(response);
      final responseData = response['response'] as Map<String, dynamic>;
      _compareToLastMonth = CompareToLastMonth.fromJson(responseData);
      notifyListeners();
    return response;
  }
}
