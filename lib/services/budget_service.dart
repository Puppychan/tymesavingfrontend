import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class BudgetService extends ChangeNotifier {
  Budget? _currentBudget;
  List<Budget> _budgets = [];

  Budget? get currentBudget => _currentBudget;
  List<Budget> get budgets => _budgets;

  Future<dynamic> fetchBudgetList(String? userId) async {
    // if (userId == null) return {'response': 'User ID is required.', 'statusCode': 400};
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.budget}/${BackendEndpoints.budgetByUserId}/$userId");
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Budget> budgetList = [];
      for (var budget in responseData) {
        print("Budget: $budget");
        final tempBudget = Budget.fromMap(budget);
        print("Temp Budget: $tempBudget");
        budgetList.add(tempBudget);
        print("After");
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
    final response =
        await NetworkService.instance.get("${BackendEndpoints.budget}/$id/info");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentBudget = Budget.fromMap(response['response']);
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
    final response = await NetworkService.instance
        .put("${BackendEndpoints.budget}/$budgetGroupId/$hostedBy", body: {
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
