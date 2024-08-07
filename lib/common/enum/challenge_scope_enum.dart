enum ChallengeScope {
  personal("Personal"),
  savingGroup("SavingGroup"),
  budgetGroup("BudgetGroup");

  const ChallengeScope(this.value);

  final String value;

  @override
  String toString() => value;

  String toStringLower() => value.toLowerCase();

  static ChallengeScope fromString(String value) {
    // get the invitation type from the value
    for (var type in ChallengeScope.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return ChallengeScope.personal;
  }

  static List<String> get list {
    return ChallengeScope.values.map((e) => e.toString()).toList();
  }
}
