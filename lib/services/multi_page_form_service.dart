import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class FormStateProvider with ChangeNotifier {
  final Map<String, dynamic> _incomeFormFields = {};
  final Map<String, dynamic> _updateIncomeFormFields = {};
  final Map<String, dynamic> _expenseFormFields = {};
  final Map<String, dynamic> _updateExpenseFormFields = {};

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
      return _validateFieldNull('category', _incomeFormFields,
          TransactionCategory.defaultIncomeCategory());
    } else if (type == FormStateType.updateIncome) {
      // return categoryExpense;
      return _validateFieldNull('category', _updateIncomeFormFields,
          TransactionCategory.defaultIncomeCategory());
    } else if (type == FormStateType.expense) {
      // return categoryExpense;
      return _validateFieldNull('category', _expenseFormFields,
          TransactionCategory.defaultExpenseCategory());
    } else if (type == FormStateType.updateExpense) {
      // return categoryExpense;
      return _validateFieldNull('category', _updateExpenseFormFields,
          TransactionCategory.defaultExpenseCategory());
    } else {
      return TransactionCategory.defaultExpenseCategory();
    }
  }

  void updateWholeForm(Map<String, dynamic> formData, FormStateType type) {
    formData.forEach((key, value) {
      if (key == "amount") {
        // TODO: format
        value = convertFormattedAmountToNumber(value);
        // value = convertFormattedNoCurrencyAmountToNumber(value);
      }

      if (type == FormStateType.income) {
        _incomeFormFields[key] = value;
      } else if (type == FormStateType.expense) {
        _expenseFormFields[key] = value;
      } else if (type == FormStateType.updateIncome) {
        _updateIncomeFormFields[key] = value;
      } else if (type == FormStateType.updateExpense) {
        _updateExpenseFormFields[key] = value;
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
    });
    notifyListeners();
  }

  String getFormattedAmount(FormStateType type) {
    // final NumberFormat formatter =
    //     NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    double amount = 0.0;
    if (type == FormStateType.income) {
      amount = _validateFieldNull('amount', _incomeFormFields, 0.0) as double;
    } else if (type == FormStateType.expense) {
      amount = _validateFieldNull('amount', _expenseFormFields, 0.0) as double;
    } else if (type == FormStateType.updateIncome) {
      amount =
          _validateFieldNull('amount', _updateIncomeFormFields, 0.0) as double;
    } else if (type == FormStateType.updateExpense) {
      amount =
          _validateFieldNull('amount', _updateExpenseFormFields, 0.0) as double;
    } else if (type == FormStateType.updateBudget) {
      amount =
          _validateFieldNull('amount', _updateBudgetFormFields, 0.0) as double;
    } else if (type == FormStateType.updateGroupSaving) {
      amount =
          _validateFieldNull('amount', _updateSavingFormFields, 0.0) as double;
    } else if (type == FormStateType.groupSaving) {
      amount = _validateFieldNull('amount', _savingFormFields, 0.0) as double;
    } else {
      amount = _validateFieldNull('amount', _budgetFormFields, 0.0) as double;
    }
    // TODO: format
    return formatAmountWithCommas(amount);
  }

  Map<String, dynamic> getFormField(FormStateType type) {
    if (type == FormStateType.income) {
      print("Current income form $_incomeFormFields");
      return _incomeFormFields;
    } else if (type == FormStateType.expense) {
      return _expenseFormFields;
    } else if (type == FormStateType.updateIncome) {
      return _updateIncomeFormFields;
    } else if (type == FormStateType.updateExpense) {
      return _updateExpenseFormFields;
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

  void setUpdateTransactionFormFields(
      Transaction? transaction, FormStateType type) {
    if (transaction == null) {
      return;
    }

    Map<String, dynamic> tempTransaction = transaction.toMapForForm();
    if (type == FormStateType.updateExpense) {
      for (var key in tempTransaction.keys) {
        if (key == "category") {
          _updateExpenseFormFields[key] =
              TransactionCategory.fromString(tempTransaction[key] as String);
        } else {
          _updateExpenseFormFields[key] = tempTransaction[key];
        }
      }
    } else {
      for (var key in tempTransaction.keys) {
        if (key == "category") {
          _updateIncomeFormFields[key] =
              TransactionCategory.fromString(tempTransaction[key] as String);
        } else {
          _updateIncomeFormFields[key] = tempTransaction[key];
        }
      }
    }
    notifyListeners();
  }

  void updateFormField(String key, dynamic value, FormStateType type) {
    if (key == "amount") {
      print("Value before convert $value");
      // // Remove any commas from the string
      // String cleanedString = value.replaceAll(',', '');

      // // Convert the cleaned string to an integer
      // value = double.tryParse(cleanedString) ?? 0;
      // TODO: format
      value = convertFormattedAmountToNumber(value);
    }

    if (type == FormStateType.income) {
      _incomeFormFields[key] = value;
      debugPrint('Income form fields: $_incomeFormFields');
    } else if (type == FormStateType.expense) {
      _expenseFormFields[key] = value;
    } else if (type == FormStateType.updateIncome) {
      _updateIncomeFormFields[key] = value;
    } else if (type == FormStateType.updateExpense) {
      _updateExpenseFormFields[key] = value;
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
    switch (type) {
      case FormStateType.memberInvitation:
        if (_memberInvitationFormFields[field] == null) {
          _memberInvitationFormFields[field] = [];
        }
        _memberInvitationFormFields[field].add(value);
        break;
      case FormStateType.income:
        if (_incomeFormFields[field] == null) {
          _incomeFormFields[field] = [];
        }
        _incomeFormFields[field].add(value);
        break;
      case FormStateType.expense:
        if (_expenseFormFields[field] == null) {
          _expenseFormFields[field] = [];
        }
        _expenseFormFields[field].add(value);
        break;
      case FormStateType.updateIncome:
        if (_updateIncomeFormFields[field] == null) {
          _updateIncomeFormFields[field] = [];
        }
        _updateIncomeFormFields[field].add(value);
        break;
      case FormStateType.updateExpense:
        if (_updateExpenseFormFields[field] == null) {
          _updateExpenseFormFields[field] = [];
        }
        _updateExpenseFormFields[field].add(value);
        break;
      default:
        debugPrint("Type not found");
    }
    notifyListeners();
  }

  void removeElementFromListField(
      String field, dynamic value, FormStateType type) {
    switch (type) {
      case FormStateType.memberInvitation:
        if (_memberInvitationFormFields[field] == null) {
          _memberInvitationFormFields[field] = [];
        }
        _memberInvitationFormFields[field].remove(value);
        break;
      case FormStateType.income:
        if (_incomeFormFields[field] == null) {
          _incomeFormFields[field] = [];
        }
        _incomeFormFields[field].remove(value);
        break;
      case FormStateType.expense:
        if (_expenseFormFields[field] == null) {
          _expenseFormFields[field] = [];
        }
        _expenseFormFields[field].remove(value);
        break;
      case FormStateType.updateIncome:
        if (_updateIncomeFormFields[field] == null) {
          _updateIncomeFormFields[field] = [];
        }
        _updateIncomeFormFields[field].remove(value);
        break;
      case FormStateType.updateExpense:
        if (_updateExpenseFormFields[field] == null) {
          _updateExpenseFormFields[field] = [];
        }
        _updateExpenseFormFields[field].remove(value);
        break;
      default:
        debugPrint("Type not found");
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
    } else if (type == FormStateType.expense) {
      _expenseFormFields['category'] = category;
    } else if (type == FormStateType.updateIncome) {
      _updateIncomeFormFields['category'] = category;
    } else if (type == FormStateType.updateExpense) {
      _updateExpenseFormFields['category'] = category;
    } else {
      _budgetFormFields['category'] = category;
    }
    notifyListeners();
  }

  void resetForm(FormStateType type) {
    print("Type in reset form $type");
    if (type == FormStateType.income) {
      _incomeFormFields.clear();
    } else if (type == FormStateType.expense) {
      _expenseFormFields.clear();
    } else if (type == FormStateType.updateIncome) {
      _updateIncomeFormFields.clear();
    } else if (type == FormStateType.updateExpense) {
      _updateExpenseFormFields.clear();
    } else if (type == FormStateType.updateBudget) {
      _updateBudgetFormFields.clear();
    } else if (type == FormStateType.updateGroupSaving) {
      _updateSavingFormFields.clear();
    } else if (type == FormStateType.groupSaving) {
      _savingFormFields.clear();
      print("Saving form fields cleared $_savingFormFields");
    } else if (type == FormStateType.memberInvitation) {
      _memberInvitationFormFields.clear();
    } else {
      _budgetFormFields.clear();
    }
    notifyListeners();
  }
}
