import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class FormStateProvider with ChangeNotifier {
  final Map<String, dynamic> _incomeFormFields = {};
  final Map<String, dynamic> _expenseFormFields = {};
  final Map<String, dynamic> _updateTransactionFormFields = {};
  Map<String, dynamic> _budgetFormFields = {};
  Map<String, dynamic> _savingFormFields = {};

  dynamic _validateFieldNull(
      String key, Map<String, dynamic> typeFormFields, dynamic defaultValue) {
    if (typeFormFields[key] == null) {
      return defaultValue;
    }
    return typeFormFields[key];
  }

  // special getters
  TransactionCategory getCategory(FormStateType type) {
    if (type == FormStateType.income) {
      return _validateFieldNull(
          'category', _incomeFormFields, TransactionCategory.defaultCategory());
    } else if (type == FormStateType.expense) {
      // return categoryExpense;
      return _validateFieldNull('category', _expenseFormFields,
          TransactionCategory.defaultCategory());
    } else if (type == FormStateType.updateTransaction) {
      return _validateFieldNull('category', _updateTransactionFormFields,
          TransactionCategory.defaultCategory());
    } else {
      // TODO: temp
      return TransactionCategory.defaultCategory();
    }
  }

  String getFormattedAmount(FormStateType type) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    double amount = 0.0;
    if (type == FormStateType.income) {
      amount = _validateFieldNull('amount', _incomeFormFields, 0.0) as double;
    } else if (type == FormStateType.expense) {
      amount = _validateFieldNull('amount', _expenseFormFields, 0.0) as double;
    } else if (type == FormStateType.updateTransaction) {
      amount = _validateFieldNull(
          'amount', _updateTransactionFormFields, 0.0) as double;
    } else {
      amount = _validateFieldNull(
          'amount', _budgetFormFields, 0.0) as double;
    }
    return formatter.format(amount);
  }



  Map<String, dynamic> getFormField(FormStateType type) {
    if (type == FormStateType.income) {
      return _incomeFormFields;
    } else if (type == FormStateType.expense) {
      return _expenseFormFields;
    } else if (type == FormStateType.updateTransaction) {
      return _updateTransactionFormFields;
    } else {
      return _budgetFormFields;
    }
  }

  void setUpdateTransactionFormFields(Transaction? transaction) {
    if (transaction == null) {
      return;
    }
    print("Before update: ${transaction.id}");
    _updateTransactionFormFields['id'] = transaction.id;
    _updateTransactionFormFields['userId'] = transaction.userId;
    _updateTransactionFormFields['description'] = transaction.description;
    _updateTransactionFormFields['payBy'] = transaction.payBy;
    _updateTransactionFormFields['amount'] = transaction.amount;
    // _updateTransactionFormFields['category'] = transaction.category;
    _updateTransactionFormFields['category'] = TransactionCategory.fromString(transaction.category);
    _updateTransactionFormFields['createdDate'] = transaction.date;
    _updateTransactionFormFields['type'] = transaction.type;
    print("after update");
    notifyListeners();
  }
  void updateFormField(String key, dynamic value, FormStateType type) {
    if (key == "amount") {
      value = convertFormattedToNumber(value);
    }

    if (type == FormStateType.income) {
      _incomeFormFields[key] = value;
      debugPrint('Income form fields: $_incomeFormFields');
    } else if (type == FormStateType.expense) {
      _expenseFormFields[key] = value;
    } else if (type == FormStateType.updateTransaction) {
      _updateTransactionFormFields[key] = value;
    } else {
      _budgetFormFields[key] = value;
    }
    notifyListeners();
  }

  void updateFormCategory(TransactionCategory category, FormStateType type) {
    if (type == FormStateType.income) {
      _incomeFormFields['category'] = category;
      debugPrint("Income form fields: $_incomeFormFields");
    } else if (type == FormStateType.expense) {
      _expenseFormFields['category'] = category;
    } else if (type == FormStateType.updateTransaction) {
      _updateTransactionFormFields['category'] = category;
    } else {
      _budgetFormFields['category'] = category;
    }
    notifyListeners();
  }
}
