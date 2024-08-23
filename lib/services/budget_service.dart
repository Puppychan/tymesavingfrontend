import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/report_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';

class BudgetService extends ChangeNotifier {
  Budget? _currentBudget;
  List<Budget> _budgets = [];
  SummaryGroup? _summaryGroup;
  ReportInfo? _reportInfo;

  Budget? get currentBudget => _currentBudget;
  List<Budget> get budgets => _budgets;
  SummaryGroup? get summaryGroup => _summaryGroup;

  List<Transaction> _transactions = [];
  List<Transaction> _awaitingApprovalTransaction = [];
  List<Transaction> _cancelledTransaction = [];
  List<ReportCategory> _reportCategoryList = [];
  List<ReportUser> _reportUserList = [];

  ReportInfo? get reportInfo => _reportInfo;
  List<ReportCategory> get reportCategoryList => _reportCategoryList;
  List<ReportUser> get reportUserList => _reportUserList;
  List<Transaction> get awaitingApprovalTransaction => _awaitingApprovalTransaction;
  List<Transaction> get transactions => _transactions;
  List<Transaction> get cancelledTransaction => _cancelledTransaction;

  Future<dynamic> fetchBudgetList(String? userId, {String? name, CancelToken? cancelToken}) async {
    // if (userId == null) return {'response': 'User ID is required.', 'statusCode': 400};
    String endpoint =
        "${BackendEndpoints.budget}/${BackendEndpoints.budgetsGetByUserId}/$userId";

    if (name != null) {
      endpoint += "?name=$name";
    }

    final response = await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
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
    String defaultApproveStatus,
    String name,
    String description,
    double amount,
    double concurrentAmount,
    String endDate,
  ) async {
    debugPrint("Before sending backend: $hostedBy, $name, $description, $amount, $concurrentAmount, $endDate");
    final response = await NetworkService.instance.post(
      BackendEndpoints.budget,
      body: {
        'hostedBy': hostedBy,
        'name': name,
        'defaultApproveStatus': defaultApproveStatus,
        'description': description,
        'amount': amount,
        'concurrentAmount': concurrentAmount,
        'endDate': endDate,
      },
    );
    debugPrint("Response when creating budget $response");
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
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.budget}/${BackendEndpoints.budgetGetSummaryById}/$id");
    if (response['response'] != null && response['statusCode'] == 200) {
      _summaryGroup = SummaryGroup.fromMap(response['response']);
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> updateBudgetGroup(
    String budgetGroupId,
    String hostedBy,
    String defaultApproveStatus,
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
          'defaultApproveStatus': defaultApproveStatus,
        });
    return response;
  }

  Future<Map<String, dynamic>> deleteBudget(String budgetId) async {
    final response = await NetworkService.instance
        .delete("${BackendEndpoints.budget}/$budgetId/${BackendEndpoints.budgetDeleteHost}");
    return response;
  }

  void disposeDetailGroup() {
    _currentBudget = null;
    _transactions = [];
    notifyListeners();
  }

  // Fetch all transaction of current budget
  Future<Map<String, dynamic>> fetchBudgetTransactions(
      String budgetGroupId) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.budget}/$budgetGroupId/transactions");
    if (response['response'] != null && response['statusCode'] == 200) {
      // debugPrint("#====== Transactions of Budget ======#");
      // debugPrint(response.toString());
      // debugPrint("#====== Transactions of Budget ======#");
      final responseData = response['response'];
      List<Transaction> transactionList = [];
      List<Transaction> awaitingApprovalTransaction= [];
      if (responseData.isNotEmpty) {
        for (var transaction in responseData) {
          if(transaction['approveStatus'] == 'Approved') {
            final tempTransaction = Transaction.fromJson(transaction);
            transactionList.add(tempTransaction);
          } else if (transaction['approveStatus'] == ApproveStatus.pending.value) {
            final tempTransaction = Transaction.fromJson(transaction);
            awaitingApprovalTransaction.add(tempTransaction);
          }
        }
      }
      _transactions = transactionList;
      _awaitingApprovalTransaction = awaitingApprovalTransaction;
      notifyListeners();
    }
    return response;
  }

  // Fetch all transaction of current budget
  Future<Map<String, dynamic>> fetchAwaitingApprovalTransactions(
      String budgetGroupId) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.budget}/$budgetGroupId/transactions");
    if (response['response'] != null && response['statusCode'] == 200) {
      // debugPrint("#====== Transactions of Budget ======#");
      // debugPrint(response.toString());
      // debugPrint("#====== Transactions of Budget ======#");
      final responseData = response['response'];
      List<Transaction> transactionPendingList = [];
      List<Transaction> transactionCancelledList = [];
      if (responseData.isNotEmpty) {
        for (var transaction in responseData) {
          if(transaction['approveStatus'] == ApproveStatus.pending.value) {
            final tempTransaction = Transaction.fromJson(transaction);
            transactionPendingList.add(tempTransaction);
          } else if (transaction['approveStatus'] == 'Declined') {
            final tempTransaction = Transaction.fromJson(transaction);
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

  // Fetch all transactions of a user by userID
  Future<Map<String, dynamic>> fetchTransactionsByUserId(
      String budgetGroupId, String userId) async {
        print("Endpoint ${"${BackendEndpoints.budget}/$budgetGroupId/transactions?userId=$userId"}");
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.budget}/$budgetGroupId/transactions?userId=$userId");

    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Transaction> transactionList = [];
      if (responseData.isNotEmpty) {
        for (var transaction in responseData) {
          final tempTransaction = Transaction.fromJson(transaction);
          transactionList.add(tempTransaction);
        }
      }
      _transactions = transactionList;
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> fetchBudgetReport(
      String budgetGroupId, String filter) async {        
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.budget}/$budgetGroupId/report?filter=$filter");
    debugPrint(response.toString());

    if (response['response'] != null && response['statusCode'] == 200) {
      final List<ReportCategory> categories = (response['response']['categories'] as List)
      .map((item) => ReportCategory.fromJson(item))
      .toList();
      final List<ReportUser> users = (response['response']['users'] as List)
      .map((item) => ReportUser.fromJson(item))
      .toList();
      final List<Transaction> transactionList = (response['response']['transactions'] as List)
      .map((item) => Transaction.fromJson(item))
      .toList();

      final ReportInfo reportInfo = ReportInfo.fromJson(response['response']['information']);
      
      _reportInfo = reportInfo;
      _reportCategoryList = categories;
      _reportUserList = users;
      _transactions = transactionList;

      notifyListeners();
    }
    return response;
  }
}
