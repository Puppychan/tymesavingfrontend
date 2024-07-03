enum InvitationStatus {
  accepted("Accepted"),
  pending("Pending"),
  cancelled("Cancelled");

  const InvitationStatus(this.value);

  final String value;

  @override
  String toString() => value;

  static InvitationStatus fromString(String value) {
    // get the invitation type from the value
    for (var type in InvitationStatus.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return InvitationStatus.pending;
  }
}
