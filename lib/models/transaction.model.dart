class Transaction {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String date;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['createdDate'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, type: $type, category: $category, amount: $amount, date: $date}';
  }
}
