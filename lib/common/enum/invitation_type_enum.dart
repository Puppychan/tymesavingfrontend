enum InvitationType {
  budget("SharedBudget"),
  savings("GroupSaving");

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
}
