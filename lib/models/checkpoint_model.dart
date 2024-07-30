class CheckPointModel{
  final String id;
  final String challengeId;
  final String name;
  final String description;
  final double checkPointValue;
  final String createdBy;
  final String startDate;
  final String endDate;

  CheckPointModel.fromMap(Map<String,dynamic> map):
  id = map['_id'],
  challengeId = map['challengeId'],
  name = map['name'],
  description = map['description'],
  checkPointValue = map['checkpointValue'],
  createdBy = map['createdBy'],
  startDate = map['startDate'],
  endDate = map['endDate']
  ;

  Map<String,dynamic> toMapForForm() {
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