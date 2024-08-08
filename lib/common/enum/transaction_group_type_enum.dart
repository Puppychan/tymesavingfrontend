enum TransactionGroupType {
  budget("Shared budget"),
  savings("Group saving"),
  none("Personal use");

  const TransactionGroupType(this.value);

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

  static TransactionGroupType fromString(String value) {
    // get the transactionGroup type from the value
    for (var type in TransactionGroupType.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return TransactionGroupType.budget;
  }

  static TransactionGroupType fromFormattedString(String formattedString) {
    // get the transactionGroup type from the formatted string
    for (var type in TransactionGroupType.values) {
      if (type.toStringFormatted() == formattedString) {
        return type;
      }
    }
    // default to customer
    return TransactionGroupType.budget;
  }

  static TransactionGroupType fromIndex(int index) {
    return TransactionGroupType.values[index];
  }

  static List<String> get formattedExpenseList {
    return TransactionGroupType.values
        .where((e) => e == TransactionGroupType.none || e == TransactionGroupType.budget)
        .map((e) => e.toStringFormatted())
        .toList();
  }

  static List<String> get formattedIncomeList {
    return TransactionGroupType.values
        .where((e) => e == TransactionGroupType.none || e == TransactionGroupType.savings)
        .map((e) => e.toStringFormatted())
        .toList();
  }
}
