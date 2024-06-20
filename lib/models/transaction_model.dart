class Transaction {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String date;
  final String? description;
  final String? payBy;
  final String? userId;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.payBy,
    this.userId,
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
        date = transaction['createdDate'];

  @override
  String toString() {
    return 'Transaction{id: $id, type: $type, category: $category, amount: $amount, date: $date}';
  }
}
