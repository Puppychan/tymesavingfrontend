class RewardHistoryModel {
  final String checkpointPassedDate;
  final String checkpointName;
  final String challengeName;
  final String category;
  final String value;

  RewardHistoryModel({
    required this.checkpointPassedDate,
    required this.checkpointName,
    required this.challengeName,
    required this.category,
    required this.value,
  });

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json) {
    // Ensure 'prize' field is not null before accessing its first item
    List<dynamic>? prizeList = json['prize'] as List<dynamic>?;
    String category = '';
    String value = '';

    // Check if prizeList is not null and has at least one item
    if (prizeList != null && prizeList.isNotEmpty) {
      category = prizeList[0]['category'] ?? '';
      value = prizeList[0]['value'] ?? '';
    }

    return RewardHistoryModel(
      checkpointPassedDate: json['checkpointPassedDate'] ?? '',
      checkpointName: json['checkpointName'] ?? '',
      challengeName: json['challengeName'] ?? '',
      category: category,
      value: value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkpointPassedDate': checkpointPassedDate,
      'checkpointName': checkpointName,
      'challengeName': challengeName,
      'category': category,
      'value': value,
    };
  }
}

