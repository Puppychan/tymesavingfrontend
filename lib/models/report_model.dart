class ReportCategory {
  final int totalAmount;
  final String category;
  final double percentage;

  ReportCategory({
    required this.totalAmount,
    required this.category,
    required this.percentage,
  });

  factory ReportCategory.fromJson(Map<String, dynamic> json) {
    return ReportCategory(
      totalAmount: json['totalAmount'],
      category: json['category'],
      percentage: json['percentage'],
    );
  }
}

class ReportUser {
  final int totalAmount;
  final String user;
  final double percentage;

  ReportUser({
    required this.totalAmount,
    required this.user,
    required this.percentage,
  });

  factory ReportUser.fromJson(Map<String, dynamic> json) {
    return ReportUser(
      totalAmount: json['totalAmount'],
      user: json['user'],
      percentage: json['percentage'],
    );
  }
}