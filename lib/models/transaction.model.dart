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
}
