import 'package:flutter/material.dart';

enum TransactionCategory {
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
  otherExpenses('Other expenses'),
  salary('Salary'), // New
  businessProfits('Business Profits'), // New
  investmentIncome('Investment Income'), // New
  freelanceWork('Freelance Work'), // New
  rentalIncome('Rental Income'); // New

  const TransactionCategory(this.name);

  final String name;

  @override
  String toString() => name;

  static TransactionCategory fromString(String name) {
    for (var category in TransactionCategory.values) {
      if (category.name == name) {
        return category;
      }
    }
    // throw ArgumentError('No category with name $name found');
    return TransactionCategory.otherExpenses;
  }

  static TransactionCategory defaultCategory() {
    return TransactionCategory.otherExpenses;
  }
}

final Map<TransactionCategory, Map<String, dynamic>> transactionCategoryData = {
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
};
