import 'package:flutter/material.dart';

enum ExpenseTransactionCategory {
  // All
  all('All'),
  // Expense Categories
  dineOut('Dine out'),
  shopping('Shopping'),
  travel('Travel'),
  entertainment('Entertainment'),
  personal('Personal'),
  transportation('Transportation'),
  rentMortgage('Rent/Mortgage'),
  utilities('Utilities'),
  billsFees('Bills & Fees'),
  health('Health'),
  education('Education'),
  groceries('Groceries'),
  gifts('Gifts'),
  work('Work'),
  otherExpenses('Other expenses');

  const ExpenseTransactionCategory(this.name);

  final String name;

  @override
  String toString() => name;

  static List<String> get list {
    return ExpenseTransactionCategory.values.map((e) => e.name).toList();
  }

  static ExpenseTransactionCategory fromString(String name) {
    for (var category in ExpenseTransactionCategory.values) {
      if (category.name == name) {
        return category;
      }
    }
    return ExpenseTransactionCategory.otherExpenses;
  }

  static ExpenseTransactionCategory defaultCategory() {
    return ExpenseTransactionCategory.otherExpenses;
  }
}

final Map<ExpenseTransactionCategory, Map<String, dynamic>> expenseCategoryData = {
  // Expense Categories
  ExpenseTransactionCategory.dineOut: {
    'icon': Icons.restaurant,
    'color': Colors.red[900]
  },
  ExpenseTransactionCategory.shopping: {
    'icon': Icons.shopping_cart,
    'color': Colors.cyan[800]
  },
  ExpenseTransactionCategory.travel: {
    'icon': Icons.airplanemode_active,
    'color': Colors.green[700]
  },
  ExpenseTransactionCategory.entertainment: {
    'icon': Icons.movie,
    'color': Colors.deepPurple[900]
  },
  ExpenseTransactionCategory.personal: {
    'icon': Icons.person,
    'color': Colors.teal[700]
  },
  ExpenseTransactionCategory.transportation: {
    'icon': Icons.directions_car,
    'color': Colors.lightBlue[800]
  },
  ExpenseTransactionCategory.rentMortgage: {
    'icon': Icons.home,
    'color': Colors.brown[400]
  },
  ExpenseTransactionCategory.utilities: {
    'icon': Icons.lightbulb,
    'color': Colors.yellow[800]
  },
  ExpenseTransactionCategory.billsFees: {'icon': Icons.receipt, 'color': Colors.grey},
  ExpenseTransactionCategory.health: {
    'icon': Icons.local_hospital,
    'color': Colors.deepOrange[700]
  },
  ExpenseTransactionCategory.education: {
    'icon': Icons.school,
    'color': Colors.indigo[600]
  },
  ExpenseTransactionCategory.groceries: {
    'icon': Icons.local_grocery_store,
    'color': Colors.lime[800]
  },
  ExpenseTransactionCategory.gifts: {
    'icon': Icons.card_giftcard,
    'color': Colors.pink[900]
  },
  ExpenseTransactionCategory.work: {'icon': Icons.work, 'color': Colors.blueAccent},
  ExpenseTransactionCategory.otherExpenses: {
    'icon': Icons.money_off,
    'color': Colors.blueGrey[400]
  },
};

