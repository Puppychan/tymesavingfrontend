import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class BudgetService extends ChangeNotifier {
  Budget? _currentBudget;
  List<Budget> _budgets = [];
  SummaryGroup? _summaryGroup;

  Budget? get currentBudget => _currentBudget;
  List<Budget> get budgets => _budgets;
  SummaryGroup? get summaryGroup => _summaryGroup;

  Future<dynamic> fetchBudgetList(String? userId) async {
    // if (userId == null) return {'response': 'User ID is required.', 'statusCode': 400};
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.budget}/${BackendEndpoints.budgetsGetByUserId}/$userId");
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Budget> budgetList = [];
      if (responseData != [] && responseData != null) {
        for (var budget in responseData) {
          final tempBudget = Budget.fromMap(budget);
          budgetList.add(tempBudget);
        }
      }
      _budgets = budgetList;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> addBudgetGroup(
    String hostedBy,
    String name,
    String description,
    double amount,
    double concurrentAmount,
    String endDate,
  ) async {
    final response = await NetworkService.instance.post(
      BackendEndpoints.budget,
      body: {
        'hostedBy': hostedBy,
        'name': name,
        'description': description,
        'amount': amount,
        'concurrentAmount': concurrentAmount,
        'endDate': endDate,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> fetchBudgetDetails(id) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.budget}/$id/info");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentBudget = Budget.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> fetchBudgetSummary(id) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.budget}/${BackendEndpoints.budgetGetSummaryById}/$id");

    print("Response from fetchBudgetSummary: $response");

    if (response['response'] != null && response['statusCode'] == 200) {
      _summaryGroup = SummaryGroup.fromMap(response['response']);
      print("Summary Budget after response: $_summaryGroup");
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> updateBudgetGroup(
    String budgetGroupId,
    String hostedBy,
    String name,
    String description,
    double amount,
    String endDate,
  ) async {
    final response = await NetworkService.instance.put(
        "${BackendEndpoints.budget}/$budgetGroupId/${BackendEndpoints.budgetUpdateHost}",
        body: {
          'name': name,
          'description': description,
          'amount': amount,
          'endDate': endDate,
        });
    return response;
  }

  Future<Map<String, dynamic>> deleteBudget(String budgetId) async {
    final response = await NetworkService.instance
        .delete("${BackendEndpoints.budget}/$budgetId");
    return response;
  }
}
