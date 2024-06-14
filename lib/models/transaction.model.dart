class Transaction {
  final String id;
  final String type;
  final String category;
  final int amount;
  final DateTime createdDate;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.createdDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      type: json['type'],
      category: json['category'],
      amount: json['amount'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
