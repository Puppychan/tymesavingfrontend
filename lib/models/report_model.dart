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
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
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
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ReportInfo{
  final String name;
  final DateTime createdDate;
  final DateTime endDate;
  final String description;
  final double concurrentAmount;
  final double amount;

  ReportInfo({
    required this.name,
    required this.createdDate,
    required this.endDate,
    required this.description,
    required this.concurrentAmount,
    required this.amount,
  }); 

   factory ReportInfo.fromJson(Map<String, dynamic> json) {
    return ReportInfo(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdDate: json['createdDate'] != null 
        ? DateTime.parse(json['createdDate']) 
        : DateTime.now(),
      endDate: json['endDate'] != null 
        ? DateTime.parse(json['endDate']) 
        : DateTime.now(),
      concurrentAmount: (json['concurrentAmount'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}