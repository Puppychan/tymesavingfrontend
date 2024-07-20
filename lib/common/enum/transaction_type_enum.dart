enum TransactionType {
  all("All"),
  income("Income"),
  expense("Expense");


  const TransactionType(this.value);

  final String value;

  @override
  String toString() => value;

  String toStringFormatted() {
    return value.splitMapJoin(
      RegExp(r"([A-Z][a-z]+)"),
      onMatch: (m) => " ${m.group(0)}",
      onNonMatch: (m) => m,
    );
  }

  static TransactionType fromString(String value) {
    // get the transactionGroup type from the value
    for (var type in TransactionType.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return TransactionType.all;
  }

  static TransactionType fromIndex(int index) {
    return TransactionType.values[index];
  }

  // list
  static List<String> get formattedList {
    return TransactionType.values.map((e) => e.toStringFormatted()).toList();
  }

  static List<String> get list {
    return TransactionType.values.map((e) => e.value).toList();
  }
}
