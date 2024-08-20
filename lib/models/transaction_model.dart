import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';

class Transaction {
  final String id;
  final String? userId;
  final String date;
  final String? description;
  final String type;
  final double amount;
  final List<String> transactionImages; // default to empty list
  final String? payBy;
  final String? savingGroupId;
  final String? budgetGroupId;
  final String category;
  final String approveStatus;
  final TransactionUser? user;

  Transaction({
    required this.id,
    this.userId,
    required this.date,
    this.description,
    required this.type,
    required this.amount,
    this.transactionImages = const [],
    this.payBy,
    this.savingGroupId,
    this.budgetGroupId,
    required this.category,
    required this.approveStatus,
    this.user,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['createdDate'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transactionImages: json['transactionImages'] != null
          ? List<String>.from(json['transactionImages'])
          : [],
      payBy: json['payBy'] ?? '',
      savingGroupId: json['savingGroupId'],
      budgetGroupId: json['budgetGroupId'],
      category: json['category'] ?? '',
      approveStatus: json['approveStatus'] ?? '',
      user:
          json['user'] != null ? TransactionUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toMapForForm() {
    return {
      'id': id,
      'userId': userId,
      'createdDate': date,
      'description': description,
      'type': type,
      'amount': amount,
      'transactionImages': transactionImages,
      'payBy': payBy,
      'savingGroupId': savingGroupId,
      'budgetGroupId': budgetGroupId,
      'category': TransactionCategory.fromString(category).toString(),
      'approveStatus': approveStatus,
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, date: $date, description: $description, type: $type, amount: $amount, transactionImages: $transactionImages, payBy: $payBy, savingGroupId: $savingGroupId, budgetGroupId: $budgetGroupId, category: $category, approveStatus: $approveStatus, user: $user)';
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
