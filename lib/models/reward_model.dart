class RewardModel{
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final List<Map<String,dynamic>> prize;

  RewardModel.fromMap(Map<String,dynamic> map):
  id = map['_id'],
  name = map['name'],
  description = map['description'],
  createdBy = map['createdBy'],
  prize = map['prize']
  ;

  Map<String, dynamic> toMapForForm(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'prize': prize,
    };
  }
}