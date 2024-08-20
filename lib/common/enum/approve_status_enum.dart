enum ApproveStatus {
  pending("Pending"),
  approved("Approved");

  const ApproveStatus(this.value);

  final String value;

  @override
  String toString() => value;

  String toStringLower() => value.toLowerCase();

  static ApproveStatus fromString(String value) {
    // get the approve status from the value
    for (var status in ApproveStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    // default to pending
    return ApproveStatus.pending;
  }

  static List<String> get list {
    return ApproveStatus.values.map((e) => e.toString()).toList();
  }
  static List<String> get inputFormList {
    return [ApproveStatus.pending.toString(), ApproveStatus.approved.toString()];
  }
}
