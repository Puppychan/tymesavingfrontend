import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class FormStateProvider with ChangeNotifier {
  final Map<String, dynamic> _incomeFormFields = {};
  final Map<String, dynamic> _expenseFormFields = {};
  final Map<String, dynamic> _updateTransactionFormFields = {};

  final Map<String, dynamic> _budgetFormFields = {};
  final Map<String, dynamic> _updateBudgetFormFields = {};

  final Map<String, dynamic> _savingFormFields = {};
  final Map<String, dynamic> _updateSavingFormFields = {};
  // invitation form
  final Map<String, dynamic> _memberInvitationFormFields = {};


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
    } else if (type == FormStateType.updateGroupSaving) {
      amount = _validateFieldNull(
          'amount', _updateSavingFormFields, 0.0) as double;
    } else if (type == FormStateType.groupSaving) {
      amount = _validateFieldNull(
          'amount', _savingFormFields, 0.0) as double;
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
    } else if (type == FormStateType.updateGroupSaving) {
      return _updateSavingFormFields;
    } else if (type == FormStateType.memberInvitation) {
      return _memberInvitationFormFields;
    } else if (type == FormStateType.groupSaving) {
      return _savingFormFields;
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
      value = convertFormattedAmountToNumber(value);
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
    } else if (type == FormStateType.updateGroupSaving) {
      _updateSavingFormFields[key] = value;
    } else if (type == FormStateType.groupSaving) {
      _savingFormFields[key] = value;
    } else if (type == FormStateType.memberInvitation) {
      _memberInvitationFormFields[key] = value;
    } else {
      _budgetFormFields[key] = value;
    }
    notifyListeners();
  }

  void addElementToListField(String field, dynamic value, FormStateType type) {
    if (FormStateType.memberInvitation == FormStateType.memberInvitation) {
      if (_memberInvitationFormFields[field] == null) {
        _memberInvitationFormFields[field] = [];
      }
      _memberInvitationFormFields[field].add(value);
    }
    notifyListeners();
  }

  void removeElementFromListField(String field, dynamic value, FormStateType type) {
    if (FormStateType.memberInvitation == FormStateType.memberInvitation) {
      if (_memberInvitationFormFields[field] == null) {
        return;
      }
      _memberInvitationFormFields[field].remove(value);
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
  void setUpdateGroupSavingFormFields(GroupSaving? goal) {
    if (goal == null) {
      return;
    }
    Map<String, dynamic> tempGroupSaving = goal.toMapForForm();
    for (var key in tempGroupSaving.keys) {
      _updateSavingFormFields[key] = tempGroupSaving[key];
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

  void resetForm(FormStateType type) {
    if (type == FormStateType.income) {
      _incomeFormFields.clear();
    } else if (type == FormStateType.expense) {
      _expenseFormFields.clear();
    } else if (type == FormStateType.updateTransaction) {
      _updateTransactionFormFields.clear();
    } else if (type == FormStateType.updateBudget) {
      _updateBudgetFormFields.clear();
    } else if (type == FormStateType.updateGroupSaving) {
      _updateSavingFormFields.clear();
    } else if (type == FormStateType.groupSaving) {
      _savingFormFields.clear();
    } else if (type == FormStateType.memberInvitation) {
      _memberInvitationFormFields.clear();
    } else {
      _budgetFormFields.clear();
    }
    notifyListeners();
  }
}
