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
  final int incomePercentage;
  final int currentExpense;
  final int expensePercentage;

  CompareToLastMonth({
    required this.currentIncome,
    required this.incomePercentage,
    required this.currentExpense,
    required this.expensePercentage,
  });

  factory CompareToLastMonth.fromJson(Map<String, dynamic> json) {
    return CompareToLastMonth(
      currentIncome: json['compareToLastMonth']['Income']['currentIncome'] as int,
      incomePercentage: json['compareToLastMonth']['Income']['incomePercentage'] as int,
      currentExpense: json['compareToLastMonth']['Expense']['currentExpense'] as int,
      expensePercentage: json['compareToLastMonth']['Expense']['expensePercentage'] as int,
    );
  }
}
