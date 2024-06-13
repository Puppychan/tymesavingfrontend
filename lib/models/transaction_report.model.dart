class ChartReport {
  Map<String, int> totals;

  ChartReport({required this.totals});

  factory ChartReport.fromJson(Map<String, dynamic> json) {
    return ChartReport(
      totals: Map<String, int>.from(json['pastMonthsTotal']),
    );
  }
}

class CompareToLastMonth {
  final int currentIncome;
  final String incomePercentage;
  final int currentExpense;
  final String expensePercentage;

  CompareToLastMonth({
    required this.currentIncome,
    required this.incomePercentage,
    required this.currentExpense,
    required this.expensePercentage,
  });

  factory CompareToLastMonth.fromJson(Map<String, dynamic> json) {
    return CompareToLastMonth(
      currentIncome: json['currentIncome'] as int,
      incomePercentage: json['incomePercentage'],
      currentExpense: json['currentExpense'] as int,
      expensePercentage: json['expensePercentage'],
    );
  }
}
