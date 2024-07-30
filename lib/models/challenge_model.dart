class ChallengeModel{
  final String id;
  final String name;
  final String description;
  final String category;

  ChallengeModel.fromMap(Map<String,dynamic> map):
  id = map['_id'],
  name = map['name'],
  description = map['description'],
  category = map['category']
  ;

  Map<String, dynamic> toMapForForm(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,

    };
  }
}

