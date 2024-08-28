enum ApproveStatus {
  pending("Pending"),
  approved("Approved");

  const ApproveStatus(this.value);

  final String value;

  @override
  String toString() => value;

  String toStringLower() => value.toLowerCase();

  static ApproveStatus fromString(String? value) {
    // get the approve status from the value
    for (var status in ApproveStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    // default to pending
    return ApproveStatus.approved;
  }

  static List<String> get list {
    return ApproveStatus.values.map((e) => e.toString()).toList();
  }

  // special for input form of group
  static List<String> get inputFormList {
    // For answerring question "Require Approval for Transactions"
    return ["Yes", "No"]; // Yes = pending, No = approved
  }
  static ApproveStatus fromInputFormString(String value) {
    // get the approve status from the value
    if (value == "Yes") {
      return ApproveStatus.pending;
    }
    // default to pending
    return ApproveStatus.approved;
  }
  
  static String toInputFormString(ApproveStatus status) {
    return status == ApproveStatus.pending ? "Yes" : "No";
  }
}