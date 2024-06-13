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

class CurrentMonthReport {
  final int totalAmount;
  final String currentMonth;

  CurrentMonthReport({required this.totalAmount, required this.currentMonth});

  factory CurrentMonthReport.fromJson(Map<String, dynamic> json) {
    /* This map will help changing the month from API call 3 letter
      to full month name!
    */
    const Map<String, String> monthMap = {
      'JAN': 'January',
      'FEB': 'February',
      'MAR': 'March',
      'APR': 'April',
      'MAY': 'May',
      'JUN': 'June',
      'JUL': 'July',
      'AUG': 'August',
      'SEP': 'September',
      'OCT': 'October',
      'NOV': 'November',
      'DEC': 'December',
    };
    // Get the abbreviated month from the JSON then convert it using the map
    String abbreviatedMonth = json['currentMonth'];
    String fullMonthValue = monthMap[abbreviatedMonth] ?? abbreviatedMonth;

    return CurrentMonthReport(
        totalAmount: json['totalAmount'], currentMonth: fullMonthValue);
  }
}

class TopCategory {
  final String category;
  final int totalAmount;
  final String percentages;

  TopCategory(
      {required this.category,
      required this.totalAmount,
      required this.percentages});

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return TopCategory(
        category: json['category'],
        totalAmount: json['totalAmount'],
        percentages: json['percentage']);
  }
}

class TopCategoriesList {
  final List<TopCategory> topCategory;

  TopCategoriesList({required this.topCategory});

  factory TopCategoriesList.fromJson(List<dynamic> json) {
    List<TopCategory> categoryList =
        json.map((e) => TopCategory.fromJson(e)).toList();
    return TopCategoriesList(topCategory: categoryList);
  }
}
