import 'package:flutter/material.dart';

enum TransactionCategory {
  // additional for filtering
  all('All'),

  // Income Categories
  salary('Salary'),
  businessProfits('Business Profits'),
  investmentIncome('Investment Income'),
  freelanceWork('Freelance Work'),
  rentalIncome('Rental Income'),
  otherIncome('Other Income'),

  // Outcomes Categories
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
  otherExpenses('Other expenses'); // New

  const TransactionCategory(this.name);

  final String name;

  @override
  String toString() => name;

  static List<String> get list {
    return TransactionCategory.values.map((e) => e.name).toList();
  }

  static TransactionCategory fromString(String name) {
    for (var category in TransactionCategory.values) {
      if (category.name == name) {
        return category;
      }
    }
    // throw ArgumentError('No category with name $name found');
    return TransactionCategory.otherExpenses;
  }

  static TransactionCategory defaultIncomeCategory() {
    return TransactionCategory.otherIncome;
  }

  static TransactionCategory defaultExpenseCategory() {
    return TransactionCategory.otherExpenses;
  }

  static List<TransactionCategory> get incomeCategories =>
      TransactionCategory.values
          .where((category) => category.index >= 1 && category.index <= 6)
          .toList();

  static List<TransactionCategory> get expenseCategories =>
      TransactionCategory.values
          .where((category) => category.index >= 7 && category.index <= 21)
          .toList();
}

final Map<TransactionCategory, Map<String, dynamic>>
    transactionExpenseCategoryData = {
  TransactionCategory.dineOut: {
    'icon': Icons.restaurant,
    'color': Colors.red[900]
  },
  TransactionCategory.shopping: {
    'icon': Icons.shopping_cart,
    'color': Colors.cyan[800]
  },
  TransactionCategory.travel: {
    'icon': Icons.airplanemode_active,
    'color': Colors.green[700]
  },
  TransactionCategory.entertainment: {
    'icon': Icons.movie,
    'color': Colors.deepPurple[900]
  },
  TransactionCategory.personal: {
    'icon': Icons.person,
    'color': Colors.teal[700]
  },
  TransactionCategory.transportation: {
    'icon': Icons.directions_car,
    'color': Colors.lightBlue[800]
  },
  TransactionCategory.rentMortgage: {
    'icon': Icons.home,
    'color': Colors.brown[400]
  },
  TransactionCategory.utilities: {
    'icon': Icons.lightbulb,
    'color': Colors.yellow[800]
  },
  TransactionCategory.billsFees: {'icon': Icons.receipt, 'color': Colors.grey},
  TransactionCategory.health: {
    'icon': Icons.local_hospital,
    'color': Colors.deepOrange[700]
  },
  TransactionCategory.education: {
    'icon': Icons.school,
    'color': Colors.indigo[600]
  },
  TransactionCategory.groceries: {
    'icon': Icons.local_grocery_store,
    'color': Colors.lime[800]
  },
  TransactionCategory.gifts: {
    'icon': Icons.card_giftcard,
    'color': Colors.pink[900]
  },
  TransactionCategory.work: {'icon': Icons.work, 'color': Colors.blueAccent},
  TransactionCategory.otherExpenses: {
    'icon': Icons.money_off,
    'color': Colors.blueGrey[400]
  },
};

final Map<TransactionCategory, Map<String, dynamic>>
    incomeTransactionCategoryData = {
  TransactionCategory.salary: {
    'icon': Icons.attach_money,
    'color': Colors.green[700]
  },
  TransactionCategory.businessProfits: {
    'icon': Icons.business,
    'color': Colors.blue[800]
  },
  TransactionCategory.investmentIncome: {
    'icon': Icons.trending_up,
    'color': Colors.orange[700]
  },
  TransactionCategory.freelanceWork: {
    'icon': Icons.work_outline,
    'color': Colors.purple[700]
  },
  TransactionCategory.rentalIncome: {
    'icon': Icons.home_work,
    'color': Colors.brown[700]
  },
  TransactionCategory.otherIncome: {
    'icon': Icons.money_off,
    'color': Colors.blueGrey[400]
  }
};

final Map<TransactionCategory, Map<String, dynamic>> transactionCategoryData = {
  ...transactionExpenseCategoryData,
  ...incomeTransactionCategoryData
};
