import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';

class FormStateProvider with ChangeNotifier {
  Map<String, dynamic> _incomeFormFields = {};
  Map<String, dynamic> _expenseFormFields = {};
  Map<String, dynamic> _budgetFormFields = {};
  Map<String, dynamic> _savingFormFields = {};


  dynamic _validateFieldNull(
      String key, Map<String, dynamic> typeFormFields, dynamic? defaultValue) {
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
    } else {
      // return categoryExpense;
      return _validateFieldNull('category', _expenseFormFields,
          TransactionCategory.defaultCategory());
    }
  }
  Map<String, dynamic> getFormField(FormStateType type) {
    if (type == FormStateType.income) {
      return _incomeFormFields;
    } else {
      return _expenseFormFields;
    }
  }

  void updateFormField(String key, dynamic value, FormStateType type) {
    if (type == FormStateType.income) {
      _incomeFormFields[key] = value;
      debugPrint('Income form fields: $_incomeFormFields');
    } else {
      _expenseFormFields[key] = value;
    }
    notifyListeners();
  }

  void updateFormCategory(TransactionCategory category, FormStateType type) {
    if (type == FormStateType.income) {
      _incomeFormFields['category'] = category;
    } else {
      _expenseFormFields['category'] = category;
    }
    notifyListeners();
  }
}
