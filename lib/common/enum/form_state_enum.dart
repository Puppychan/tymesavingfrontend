enum FormStateType {
  income('Income'),
  expense('Expense'),
  updateTransaction('UpdateTransaction'),
  saving('Saving'),
  budget('Budget'),
  goal('Goal'),
  updateGoal("UpdateGoal"),
  updateBudget('UpdateBudget');

  final String value;
  const FormStateType(this.value);

  static FormStateType fromString(String value) {
    return FormStateType.values.firstWhere((e) => e.value == value);
  }

  @override
  String toString() {
    return value;
  }
}
