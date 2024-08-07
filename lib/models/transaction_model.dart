import 'package:tymesavingfrontend/common/enum/expense_transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/income_transaction_category_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_type_enum.dart';

class Transaction {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String date;
  final String? description;
  final String? payBy;
  final String? userId;
  final TransactionUser? user;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.payBy,
    this.userId,
    this.user,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['createdDate'] ?? '',
      description: json['description'] ?? '',
      payBy: json['payBy'] ?? '',
      userId: json['userId'] ?? '',
      user:
          json['user'] != null ? TransactionUser.fromJson(json['user']) : null,
    );
  }

  Transaction.fromMap(Map<String, dynamic> transaction)
      : id = transaction['_id'],
        userId = transaction['userId'],
        description = transaction['description'],
        payBy = transaction['payBy'],
        type = transaction['type'],
        category = transaction['category'],
        amount = transaction['amount'].toDouble(),
        date = transaction['createdDate'],
        user = transaction['user'] != null
            ? TransactionUser.fromJson(transaction['user'])
            : null;

  Map<String, dynamic> toMapForForm() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'payBy': payBy,
      'amount': amount,
      'category': type == TransactionType.expense.toString() ? ExpenseTransactionCategory.fromString(category).toString()
      : IncomeTransactionCategory.fromString(category).toString(),
      'createdDate': date,
      'type': type,
      'user': user != null ? user!.toJson() : null,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, type: $type, category: $category, amount: $amount, date: $date, user: $user}';
  }
}

class TransactionUser {
  final String id;
  final String username;
  final String fullname;
  final String phone;

  TransactionUser({
    required this.id,
    required this.username,
    required this.fullname,
    required this.phone,
  });

  factory TransactionUser.fromJson(Map<String, dynamic> json) {
    return TransactionUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'fullname': fullname,
      'phone': phone,
    };
  }

  @override
  String toString() {
    return 'TransactionUser{id: $id, username: $username, fullname: $fullname, phone: $phone}';
  }
}
