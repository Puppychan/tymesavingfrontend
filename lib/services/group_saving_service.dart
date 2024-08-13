import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';

class GroupSavingService extends ChangeNotifier {
  GroupSaving? _currentGroupSaving;
  List<GroupSaving> _groupSavings = [];
  SummaryGroup? _summaryGroup;

  GroupSaving? get currentGroupSaving => _currentGroupSaving;
  List<GroupSaving> get groupSavings => _groupSavings;
  SummaryGroup? get summaryGroup => _summaryGroup;

  List<Transaction> _transactions = [];
  List<Transaction> _awaitingApprovalTransaction = [];
  List<Transaction> _cancelledTransaction = [];

  List<Transaction> get transactions => _transactions;
  List<Transaction> get awaitingApprovalTransaction => _awaitingApprovalTransaction;
  List<Transaction> get cancelledTransaction => _cancelledTransaction;

  Future<dynamic> fetchGroupSavingList(String? userId, {String? name, CancelToken? cancelToken}) async {
    // if (userId == null) return {'response': 'User ID is required.', 'statusCode': 400};
    String endpoint =
        "${BackendEndpoints.groupSaving}/${BackendEndpoints.groupSavingsGetByUserId}/$userId";
    if (name != null) {
      endpoint += "?name=$name";
    }

    final response = await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<GroupSaving> groupSavingList = [];
      if (responseData != [] && responseData != null) {
        for (var groupSaving in responseData) {
          print("Before group saving");
          final tempGroupSaving = GroupSaving.fromMap(groupSaving);
          print("After group saving");
          groupSavingList.add(tempGroupSaving);
        }
      }
      _groupSavings = groupSavingList;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> addGroupSavingGroup(
    String hostedBy,
    String name,
    String description,
    double amount,
    double concurrentAmount,
    String endDate,
  ) async {
    final response = await NetworkService.instance.post(
      BackendEndpoints.groupSaving,
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

  Future<Map<String, dynamic>> fetchGroupSavingDetails(id) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.groupSaving}/$id/info");
    if (response['response'] != null && response['statusCode'] == 200) {
      _currentGroupSaving = GroupSaving.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> fetchGroupSavingSummary(id) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.groupSaving}/${BackendEndpoints.groupSavingGetSummaryById}/$id");
    if (response['response'] != null && response['statusCode'] == 200) {
      _summaryGroup = SummaryGroup.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> updateGroupSavingGroup(
    String groupSavingGroupId,
    String hostedBy,
    String name,
    String description,
    double amount,
    String endDate,
  ) async {
    final response = await NetworkService.instance.put(
        "${BackendEndpoints.groupSaving}/$groupSavingGroupId/${BackendEndpoints.groupSavingUpdateHost}",
        body: {
          'name': name,
          'description': description,
          'amount': amount,
          'endDate': endDate,
        });
    return response;
  }

  Future<Map<String, dynamic>> deleteGroupSaving(String groupSavingId) async {
    final response = await NetworkService.instance
        .delete("${BackendEndpoints.groupSaving}/$groupSavingId/${BackendEndpoints.groupSavingDeleteHost}");
    return response;
  }

  void disposeDetailGroup() {
    _currentGroupSaving = null;
    _transactions = [];
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchGroupSavingTransactions(
      String groupSavingGroupId) async {
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.groupSaving}/$groupSavingGroupId/transactions");

    if (response['response'] != null && response['statusCode'] == 200) {
      debugPrint("#====== Transactions of GroupSaving ======#");
      debugPrint(response.toString());
      debugPrint("#====== Transactions of GroupSaving ======#");
      final responseData = response['response'];
      List<Transaction> transactionList = [];
      if (responseData.isNotEmpty) {
        for (var transaction in responseData) {
          final tempTransaction = Transaction.fromMap(transaction);
          transactionList.add(tempTransaction);
        }
      }
      _transactions = transactionList;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> fetchAwaitingApprovalTransactions(
      String savingGroupId) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.groupSaving}/$savingGroupId/transactions");
    if (response['response'] != null && response['statusCode'] == 200) {
      // debugPrint("#====== Transactions of Budget ======#");
      // debugPrint(response.toString());
      // debugPrint("#====== Transactions of Budget ======#");
      final responseData = response['response'];
      List<Transaction> transactionPendingList = [];
      List<Transaction> transactionCancelledList = [];
      if (responseData.isNotEmpty) {
        for (var transaction in responseData) {
          if(transaction['approveStatus'] == 'Pending') {
            final tempTransaction = Transaction.fromMap(transaction);
            transactionPendingList.add(tempTransaction);
          } else if (transaction['approveStatus'] == 'Declined') {
            final tempTransaction = Transaction.fromMap(transaction);
            transactionCancelledList.add(tempTransaction);
          }
        }
      }
      _awaitingApprovalTransaction = transactionPendingList;
      _cancelledTransaction = transactionCancelledList;
      notifyListeners();
    }
    return response;
  }
}
