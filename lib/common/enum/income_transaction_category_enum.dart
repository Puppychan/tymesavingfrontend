import 'package:flutter/material.dart';

enum IncomeTransactionCategory {
  // All
  all('All'),

  // Income Categories
  salary('Salary'),
  businessProfits('Business Profits'),
  investmentIncome('Investment Income'),
  freelanceWork('Freelance Work'),
  rentalIncome('Rental Income'),
  otherIncome('Other Income');

  const IncomeTransactionCategory(this.name);

  final String name;

  @override
  String toString() => name;

  static List<String> get list {
    return IncomeTransactionCategory.values.map((e) => e.name).toList();
  }

  static IncomeTransactionCategory fromString(String name) {
    for (var category in IncomeTransactionCategory.values) {
      if (category.name == name) {
        return category;
      }
    }
    return IncomeTransactionCategory.otherIncome;
  }

  static IncomeTransactionCategory defaultCategory() {
    return IncomeTransactionCategory.otherIncome;
  }
}

final Map<IncomeTransactionCategory, Map<String, dynamic>> incomeCategoryData = {
  IncomeTransactionCategory.salary: {
    'icon': Icons.attach_money,
    'color': Colors.green[700]
  },
  IncomeTransactionCategory.businessProfits: {
    'icon': Icons.business,
    'color': Colors.blue[800]
  },
  IncomeTransactionCategory.investmentIncome: {
    'icon': Icons.trending_up,
    'color': Colors.orange[700]
  },
  IncomeTransactionCategory.freelanceWork: {
    'icon': Icons.work_outline,
    'color': Colors.purple[700]
  },
  IncomeTransactionCategory.rentalIncome: {
    'icon': Icons.home_work,
    'color': Colors.brown[700]
  },
  IncomeTransactionCategory.otherIncome: {
    'icon': Icons.money,
    'color': Colors.blueGrey[400]
  },
};
