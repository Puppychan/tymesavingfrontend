enum TransactionGroupType {
  budget("SharedBudget"),
  savings("GroupSaving"),
  none("None");

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

  // list
  static List<String> get formattedList {
    return TransactionGroupType.values.map((e) => e.toStringFormatted()).toList();
  }
}
