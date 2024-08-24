import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_type_enum.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
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
  Map<String, List<Transaction>>? _transactions;
  Transaction? _detailedTransaction;
  Map<String, String> _filterOptions = {
    "getTransactionType": 'All',
    "getCategory": 'All',
    // "getDateCreated":
  };
  Map<String, String> _sortOptions = {
    "sortDateCreated": 'ascending',
    "sortDateUpdated": 'ascending',
    "sortAmount": 'ascending',
  };

  // Getter to access outside of this class
  CompareToLastMonth? get compareToLastMonth => _compareToLastMonth;
  ChartReport? get chartReport => _chartReport;
  ChartReport? get chartReportSecondary => _chartReportSecondary;
  CurrentMonthReport? get currrentMonthReport => _currentMonthReport;
  TopCategoriesList? get topCategoriesList => _topCategoriesList;
  NetSpend? get netSpend => _netSpend;
  Map<String, List<Transaction>>? get transactions => _transactions;
  Transaction? get detailedTransaction => _detailedTransaction;
  Map<String, String> get filterOptions => _filterOptions;
  Map<String, String> get sortOptions => _sortOptions;

  String convertOptionToUI(String option) {
    // Convert sort option to readable string to display in the UI
    // if (optionType == 'sort') {
    switch (option) {
      case 'sortDateCreated':
        return "Created date";
      case 'sortDateUpdated':
        return "Updated date";
      case 'sortAmount':
        return "Transaction amount";
      default:
        return "";
    }
  }

  void setOptions(String type, String newOption, String newValue) {
    if (type == "sort") {
      // if type of option is sort
      String convertedOption;
      switch (newOption) {
        case 'Created date':
          convertedOption = "sortDateCreated";
          break;
        case 'Updated date':
          convertedOption = "sortDateUpdated";
          break;
        case 'Transaction amount':
          convertedOption = "sortAmount";
          break;
        default:
          convertedOption = "";
      }
      if (_sortOptions.keys.contains(convertedOption)) {
        if (newValue == 'ascending' || newValue == 'descending') {
          _sortOptions = {..._sortOptions, convertedOption: newValue};
          notifyListeners();
        }
      }
    } else {
      // if type of option is filter

      if ((newOption == 'getTransactionType' &&
              TransactionType.list.contains(newValue)) ||
          (newOption == 'getCategory' &&
              TransactionCategory.list.contains(newValue))) {
        _filterOptions = {..._filterOptions, newOption: newValue};
        notifyListeners();
      }
    }
  }

  String _convertOptionsToParams() {
    // used for creating query params for the API for fetching transactions
    // "?sortOption1=value1&sortOption2=value2&sortOption3=value3"
    String returnParams =
        _sortOptions.entries.map((e) => "${e.key}=${e.value}").join('&');
    returnParams = "?$returnParams";

    // eliminate if filter option is 'All'
    for (var key in _filterOptions.keys) {
      if (_filterOptions[key] != 'All') {
        // add filter option to the returnParams
        returnParams += "&$key=${_filterOptions[key]}";
      }
    }

    return returnParams;
  }

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

  Future<Map<String, dynamic>> createTransaction(
      String userId,
      String createdDate,
      String description,
      FormStateType type,
      double amount,
      String payBy,
      TransactionCategory category,
      List<String> transactionImages,
      {String? savingGroupId,
      String? budgetGroupId,
      ApproveStatus? approveStatus}) async {
    // Prepare the list of MultipartFiles or just image URLs
    List<dynamic> imageFiles =
        await Future.wait(transactionImages.map((imagePath) async {
      if (imagePath.startsWith('http')) {
        // If it's a URL, send it as is
        return imagePath;
      } else {
        // If it's a file path, convert it to a MultipartFile
        return await MultipartFile.fromFile(imagePath,
            filename: imagePath.split('/').last);
      }
    }).toList());

    final FormData formData = FormData.fromMap({
      "userId": userId,
      "description": description,
      "type": type.value,
      "amount": amount,
      "payBy": payBy,
      "category": category.name,
      if (savingGroupId != null) "savingGroupId": savingGroupId,
      if (budgetGroupId != null) "budgetGroupId": budgetGroupId,
      "approveStatus": approveStatus?.value ?? ApproveStatus.approved.value,
      "createdDate": createdDate,
      "image": imageFiles, // This is the key your backend expects for images
    });
    final response = await NetworkService.instance
        .postFormData(BackendEndpoints.transaction, data: formData);
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      _detailedTransaction = Transaction.fromJson(responseData);
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> updateTransaction(
      String transactionId,
      String createdDate,
      String description,
      // FormStateType type,
      double amount,
      String payBy,
      TransactionCategory category) async {
    // print type of all
    final response = await NetworkService.instance
        .put("${BackendEndpoints.transaction}/$transactionId", body: {
      'createdDate': createdDate,
      'description': description,
      // 'type': type.value, //
      'amount': amount,
      'payBy': payBy,
      'category': category.name,
    });
    print("response in updating transaction $response");
    return response;
  }

  Future<Map<String, dynamic>> getBothChartReport(userid) async {
    final expenseResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Expense&userId=$userid");
    final incomeResponse = await NetworkService.instance.get(
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReport}?transactionType=Income&userId=$userid");
    final responseDataExpense = expenseResponse['response'];
    final responseDataIncome = incomeResponse['response'];
    notifyListeners();
    _chartReport = ChartReport.fromJson(responseDataExpense);
    _chartReportSecondary = ChartReport.fromJson(responseDataIncome);
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

  Future<Map<String, dynamic>> getTransaction(transactionId) async {
    final response = await NetworkService.instance
        .get("${BackendEndpoints.transaction}/$transactionId");
    // final responseData = response['response'];
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      _detailedTransaction = Transaction.fromJson(responseData);
      print("Detailed transaction: $_detailedTransaction");
      notifyListeners();
    }
    return response;
  }

  Future<Map<String, dynamic>> fetchTransactions(id) async {
    String normalizeMonthName(String month) {
      switch (month.toUpperCase()) {
        case 'JAN':
          return 'Jan';
        case 'FEB':
          return 'Feb';
        case 'MAR':
          return 'Mar';
        case 'APR':
          return 'Apr';
        case 'MAY':
          return 'May';
        case 'JUN':
          return 'Jun';
        case 'JUL':
          return 'Jul';
        case 'AUG':
          return 'Aug';
        case 'SEP':
          return 'Sep';
        case 'OCT':
          return 'Oct';
        case 'NOV':
          return 'Nov';
        case 'DEC':
          return 'Dec';
        default:
          return month;
      }
    }

    String endpoint =
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReportByUser}/$id";
    endpoint += _convertOptionsToParams();
    final response = await NetworkService.instance.get(endpoint);

    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'] as Map<String, dynamic>;

      final transactions =
          responseData.map<String, List<Transaction>>((month, transactions) {
        final transactionList = (transactions['transactions'] as List<dynamic>)
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();

        return MapEntry(normalizeMonthName(month), transactionList);
      });
      _transactions = transactions;
      print('Parsed transactions: $transactions');

      notifyListeners();
      // return transactions;
    } else {
      print(
          'Failed to load transactions. Status code: ${response['statusCode']}');
      // throw Exception('Failed to load transactions');
    }
    return response;
  }

  Future<List<Transaction>> fetchTransactionsSortHandler({
    required String tab,
    required String sortOption,
    required String sortOrder,
    required String userId,
  }) async {
    // Build the base endpoint URL
    String endpoint =
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReportByUser}/$userId";

    // Initialize query parameters
    Map<String, String> queryParams = {
      sortOption: sortOrder,
    };

    // Apply filtering based on the selected tab
    if (tab == 'Income') {
      queryParams['type'] = 'Income';
    } else if (tab == 'Expense') {
      queryParams['type'] = 'Expense';
    }

    // Convert query parameters to a query string
    String queryString =
        queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

    // Construct the full URL with query parameters
    String url = '$endpoint?$queryString';

    print(url);

    // Execute the API call
    final response = await NetworkService.instance.get(url);

    print(response);

    // return [];

    // Handle response
    if (response['statusCode'] == 200 && response['response'] != null) {
      final responseData = response['response'] as Map<String, dynamic>;

      // Flatten the transactions list
      List<dynamic> allTransactions = [];
      responseData.forEach((key, value) {
        if (value['transactions'] != null) {
          allTransactions.addAll(value['transactions']);
        }
      });

      // Convert to List<Transaction>
      List<Transaction> transactions =
          allTransactions.map((data) => Transaction.fromJson(data)).toList();

      return transactions;
    } else {
      // Handle errors appropriately
      throw Exception(
          'Failed to load transactions. Status code: ${response['statusCode']}');
    }
  }

  // Get transaction list of month and year
  Future<List<Transaction>> fetchTransactionsByMonthAndYear(
      String userId, int year, int month) async {
    // Ensure that month is two digits
    String monthStr = month.toString().padLeft(2, '0');
    String yearStr = year.toString();

    // Construct the endpoint with the provided year and month
    String endpoint =
        "${BackendEndpoints.transaction}/${BackendEndpoints.transactionReportByUser}/$userId";

    // Add the filter for the specified month and year
    endpoint += "?createdDate=$yearStr-$monthStr";

    // Convert any sort and filter options to query parameters
    endpoint += _convertOptionsToParams();

    final response = await NetworkService.instance.get(endpoint);

    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'] as Map<String, dynamic>;

      if (responseData.isNotEmpty) {
        // Extract the first key (month) from the response data
        final monthKey = responseData.keys.first;

        // Extract the transactions list for the month
        final transactionsList =
            (responseData[monthKey]['transactions'] as List<dynamic>)
                .map((transaction) => Transaction.fromJson(transaction))
                .toList();

        return transactionsList;
      } else {
        print('No transactions found for the specified month and year.');
        return []; // Return an empty list if the response is empty
      }
    } else {
      print(
          'Failed to load transactions. Status code: ${response['statusCode']}');
      return []; // Return an empty list in case of failure
    }
  }

  Future<Map<String, dynamic>> approveTransaction(String transactionId) async {
    final response = await NetworkService.instance.post(
        "${BackendEndpoints.transaction}/$transactionId/${BackendEndpoints.approveTransaction}");
    return response;
  }

  Future<Map<String, dynamic>> cancelledTransaction(
      String transactionId) async {
    final response = await NetworkService.instance.post(
        "${BackendEndpoints.transaction}/$transactionId/${BackendEndpoints.cancelledTransaction}");
    return response;
  }
}
