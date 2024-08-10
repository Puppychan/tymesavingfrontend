enum FormStateType {
  income('Income'),
  expense('Expense'),
  updateIncome('UpdateIncome'),
  updateExpense('UpdateExpense'),
  updateTransaction('UpdateTransaction'),
  budget('Budget'),
  groupSaving('GroupSaving'),
  updateGroupSaving("UpdateGroupSaving"),
  updateBudget('UpdateBudget'),
  // other type of form
  memberInvitation("MemberInvitation");

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
