import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/goal_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class FormStateProvider with ChangeNotifier {
  final Map<String, dynamic> _incomeFormFields = {};
  final Map<String, dynamic> _expenseFormFields = {};
  final Map<String, dynamic> _updateTransactionFormFields = {};
  final Map<String, dynamic> _budgetFormFields = {};
  final Map<String, dynamic> _updateBudgetFormFields = {};
  final Map<String, dynamic> _updateGoalFormFields = {};
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
    } else if (type == FormStateType.updateBudget) {
      amount = _validateFieldNull(
          'amount', _updateBudgetFormFields, 0.0) as double;
    } else if (type == FormStateType.updateGoal) {
      amount = _validateFieldNull(
          'amount', _updateGoalFormFields, 0.0) as double;
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
    } else if (type == FormStateType.updateBudget) {
      return _updateBudgetFormFields;
    } else if (type == FormStateType.updateGoal) {
      return _updateGoalFormFields;
    } else {
      return _budgetFormFields;
    }
  }

  void setUpdateTransactionFormFields(Transaction? transaction) {
    if (transaction == null) {
      return;
    }

    Map<String, dynamic> tempTransaction = transaction.toMapForForm();

    for (var key in tempTransaction.keys) {
      _updateTransactionFormFields[key] = tempTransaction[key];
    }
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
    } else if (type == FormStateType.updateBudget) {
      _updateBudgetFormFields[key] = value;
    } else if (type == FormStateType.updateGoal) {
      _updateGoalFormFields[key] = value;
    } else {
      _budgetFormFields[key] = value;
    }
    notifyListeners();
  }

  void setUpdateBudgetFormFields(Budget? budget) {
    if (budget == null) {
      return;
    }
    Map<String, dynamic> tempBudget = budget.toMapForForm();
    for (var key in tempBudget.keys) {
      _updateBudgetFormFields[key] = tempBudget[key];
    }
    notifyListeners();
  }
  void setUpdateGoalFormFields(Goal? goal) {
    if (goal == null) {
      return;
    }
    Map<String, dynamic> tempGoal = goal.toMapForForm();
    for (var key in tempGoal.keys) {
      _updateGoalFormFields[key] = tempGoal[key];
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
