class ChallengeModel{
  final String id;
  final String name;
  final String description;
  final String category;
  final String scope;
  final String budgetGroupId;
  final String startDate;
  final String endDate;
  final String createdBy;

  ChallengeModel.fromMap(Map<String,dynamic> map):
  id = map['_id'],
  name = map['name'],
  description = map['description'],
  category = map['category'],
  scope = map['scope'],
  budgetGroupId = map['budgetGroupId'],
  startDate = map['startDate'],
  endDate = map['endDate'],
  createdBy = map['createdBy']
  ;

  Map<String, dynamic> toMapForForm(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'scope': scope,
      'budgetGroupId': budgetGroupId,
      'startDate': startDate,
      'endDate': endDate,
      'createdBy': createdBy
    };
  }
}

