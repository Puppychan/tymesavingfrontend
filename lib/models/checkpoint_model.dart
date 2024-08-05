
class CheckPointModel {
  final String id;
  final String challengeId;
  final String name;
  final String description;
  final double checkPointValue;
  final String createdBy;
  final String startDate;
  final String endDate;

  CheckPointModel({
    required this.id,
    required this.challengeId,
    required this.name,
    required this.description,
    required this.checkPointValue,
    required this.createdBy,
    required this.startDate,
    required this.endDate,
  });

  factory CheckPointModel.fromMap(Map<String, dynamic> map) {
    return CheckPointModel(
      id: map['_id'] ?? '',
      challengeId: map['challengeId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      checkPointValue: (map['checkpointValue'] as num?)?.toDouble() ?? 0.0,
      createdBy: map['createdBy'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toMapForForm() {
    return {
      'id': id,
      'challengeId': challengeId,
      'name': name,
      'description': description,
      'checkpointValue': checkPointValue,
      'createdBy': createdBy,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}