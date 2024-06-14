enum InvitationType {
  budget("Budget"),
  saving("Saving");

  const InvitationType(this.value);

  final String value;

  @override
  String toString() => value;

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
