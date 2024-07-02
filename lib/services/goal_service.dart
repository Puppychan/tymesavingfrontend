import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/goal_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class GoalService extends ChangeNotifier {
  Goal? _currentGoal;
  List<Goal> _goals = [];

  Goal? get currentGoal => _currentGoal;
  List<Goal> get goals => _goals;

  Future<dynamic> fetchGoalList(String? userId) async {
    // if (userId == null) return {'response': 'User ID is required.', 'statusCode': 400};
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.goal}/${BackendEndpoints.goalByUserId}/$userId");
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Goal> goalList = [];
      for (var goal in responseData) {
        final tempGoal = Goal.fromMap(goal);
        goalList.add(tempGoal);
      }
      _goals = goalList;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> addGoalGroup(
    String hostedBy,
    String name,
    String description,
    double amount,
    double concurrentAmount,
    String endDate,
  ) async {
    final response = await NetworkService.instance.post(
      BackendEndpoints.goal,
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

  Future<Map<String, dynamic>> fetchGoalDetails(id) async {
    final response =
        await NetworkService.instance.get("${BackendEndpoints.goal}/$id");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentGoal = Goal.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> updateGoalGroup(
    String goalGroupId,
    String hostedBy,
    String name,
    String description,
    double amount,
    String endDate,
  ) async {
    final response = await NetworkService.instance
        .put("${BackendEndpoints.goal}/$goalGroupId/$hostedBy", body: {
      'name': name,
      'description': description,
      'amount': amount,
      'endDate': endDate,
    });
    return response;
  }

  Future<Map<String, dynamic>> deleteGoal(String goalId) async {
    final response = await NetworkService.instance
        .delete("${BackendEndpoints.goal}/$goalId");
    return response;
  }
}
