class ChallengeModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String scope;
  final String budgetGroupId;
  final DateTime startDate;
  final DateTime endDate;
  final String createdBy;
  final bool isPublished;

  ChallengeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.scope,
    required this.budgetGroupId,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.isPublished
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      category: map['category'] as String,
      scope: map['scope'] as String,
      budgetGroupId: map['budgetGroupId'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      createdBy: map['createdBy'] as String,
      isPublished: map['isPublished'] as bool,
    );
  }


  Map<String, dynamic> toMapForForm() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'scope': scope,
      'budgetGroupId': budgetGroupId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdBy': createdBy,
      'isPublish': isPublished,
    };
  }
}

class ChallengeDetailMemberModel {
  final String id;
  final String username;
  final String email;
  final String fullname;
  final String phone;
  final String? avatar;
  final String tymeReward;

  ChallengeDetailMemberModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullname,
    required this.phone,
    this.avatar,
    required this.tymeReward,
  });

  factory ChallengeDetailMemberModel.fromMap(Map<String, dynamic> map) {
    return ChallengeDetailMemberModel(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      fullname: map['fullname'] as String,
      phone: map['phone'] as String,
      avatar: map['avatar'] as String?,
      tymeReward: map['tymeReward'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'avatar': avatar,
      'tymeReward': tymeReward,
    };
  }
}
