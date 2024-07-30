enum InvitationType {
  budget("SharedBudget"),
  savings("GroupSaving"),
  all("All");

  const InvitationType(this.value);

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

  static InvitationType fromString(String value) {
    // get the invitation type from the value
    for (var type in InvitationType.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return InvitationType.budget;
  }

  static InvitationType fromIndex(int index) {
    return InvitationType.values[index];
  }

  // list
  static List<String> get formattedList {
    return InvitationType.values.map((e) => e.toStringFormatted()).toList();
  }

  static List<String> get list{
    return InvitationType.values.map((e) => e.toString()).toList();
  }
}
