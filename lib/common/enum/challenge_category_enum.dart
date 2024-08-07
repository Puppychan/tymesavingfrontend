enum ChallengeCategory {
  saving("Saving"),
  spending("Spending");

  const ChallengeCategory(this.value);

  final String value;

  @override
  String toString() => value;

  String toStringLower() => value.toLowerCase();

  static ChallengeCategory fromString(String value) {
    // get the invitation type from the value
    for (var type in ChallengeCategory.values) {
      if (type.value == value) {
        return type;
      }
    }
    // default to customer
    return ChallengeCategory.saving;
  }

  static List<String> get list {
    return ChallengeCategory.values.map((e) => e.toString()).toList();
  }
}
