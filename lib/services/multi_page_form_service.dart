import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class FormStateProvider with ChangeNotifier {
  Map<String, dynamic> _incomeFormFields = {};
  Map<String, dynamic> _expenseFormFields = {};
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
    } else {
      // return categoryExpense;
      return _validateFieldNull('category', _expenseFormFields,
          TransactionCategory.defaultCategory());
    }
  }

  String getFormattedAmount(FormStateType type) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    double amount = 0.0;
    if (type == FormStateType.income) {
      amount = _validateFieldNull('amount', _incomeFormFields, 0.0) as double;
    } else {
      amount = _validateFieldNull('amount', _expenseFormFields, 0.0) as double;
    }
    return formatter.format(amount);
  }
  // String getFormattedDate(FormStateType type) {
  //   // final DateFormat formatter = DateFormat('dd/MM/yyyy');
  //   DateTime date = DateTime.now();
  //   if (type == FormStateType.income) {
  //     date = _validateFieldNull('createdDate', _incomeFormFields, DateTime.now()) as DateTime;
  //   } else {
  //     date = _validateFieldNull('createdDate', _expenseFormFields, DateTime.now()) as DateTime;
  //   }
  //   return formatter.format(date);
  // }




  Map<String, dynamic> getFormField(FormStateType type) {
    if (type == FormStateType.income) {
      return _incomeFormFields;
    } else {
      return _expenseFormFields;
    }
  }

  void updateFormField(String key, dynamic value, FormStateType type) {
    if (key == "amount") {
      value = convertFormattedToNumber(value);
    }

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
      debugPrint("Income form fields: $_incomeFormFields");
    } else {
      _expenseFormFields['category'] = category;
    }
    notifyListeners();
  }

  void updateFormTitle(String title, FormStateType type) {
    if (type == FormStateType.income) {
      _incomeFormFields['title'] = title;
    } else {
      _expenseFormFields['title'] = title;
    }
    notifyListeners();
  }
}
