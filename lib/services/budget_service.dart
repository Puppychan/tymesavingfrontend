import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class BudgetService extends ChangeNotifier {
  Budget? _currentBudget;

  Budget? get currentBudget => _currentBudget;

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

  // Future<Map<String, dynamic>> fetchBudgetGroup() async {
  //   final response = await NetworkService.instance.get(BackendEndpoints.budget);
  //   final responseData = response['response'];
  //   List<Budget> budgetList = [];
  //   for (var budget in responseData) {
  //     budgetList.add(Budget.fromMap(budget));
  //   }
  //   notifyListeners();
  //   return response;
  // }

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
}
