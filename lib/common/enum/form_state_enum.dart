enum FormStateType {
  income('Income'),
  expense('Expense'),
  updateTransaction('UpdateTransaction'),
  saving('Saving'),
  budget('Budget');

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
