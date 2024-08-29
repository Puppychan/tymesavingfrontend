class ChallengeModel {
  final String id;
  final String name;
  final String groupName;
  final String description;
  final String category;
  final String scope;
  final String budgetGroupId;
  final DateTime startDate;
  final DateTime endDate;
  final String createdBy;
  final String createdByFullName;
  final bool isPublished;

  ChallengeModel({
    required this.id,
    required this.name,
    required this.groupName,
    required this.description,
    required this.category,
    required this.scope,
    required this.budgetGroupId,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.isPublished,
    required this.createdByFullName,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
  return ChallengeModel(
    // Handle null by providing a default value
    id: map['_id'] as String? ?? '',  
    name: map['name'] as String? ?? '', 
    description: map['description'] as String? ?? '',
    groupName: map['groupName'] as String? ?? '',
    category: map['category'] as String? ?? '',
    scope: map['scope'] as String? ?? '', 
    budgetGroupId: map['budgetGroupId'] as String? ?? '',
    startDate: DateTime.tryParse(map['startDate'] as String? ?? '') ?? DateTime.now(), 
    endDate: DateTime.tryParse(map['endDate'] as String? ?? '') ?? DateTime.now(), 
    createdBy: map['createdBy'] as String? ?? '', 
    isPublished: map['isPublished'] as bool? ?? false, 
    createdByFullName: map['createdByFullName'] ?? '',
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
      'groupName': groupName,
    };
  }

   @override
  String toString() {
    return 'ChallengeModel(id: $id, name: $name, groupName: $groupName, description: $description, '
           'category: $category, scope: $scope, budgetGroupId: $budgetGroupId, '
           'startDate: $startDate, endDate: $endDate, createdBy: $createdBy, '
           'isPublished: $isPublished)';
  }
}

class ChallengeDetailMemberModel {
  final String id;
  final String username;
  final String email;
  final String fullname;
  final String phone;
  final String? avatar;
  final String? tymeReward;
  final int checkpointReached;
  final int progressAmount;
  

  ChallengeDetailMemberModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullname,
    required this.phone,
    required this.checkpointReached,
    required this.progressAmount,
    this.avatar,
    this.tymeReward,
  });

  factory ChallengeDetailMemberModel.fromMap(Map<String, dynamic> map) {
    return ChallengeDetailMemberModel(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      fullname: map['fullname'] as String,
      phone: map['phone'] as String,
      avatar: map['avatar'] as String?,
      tymeReward: map['tymeReward'] as String?,
      checkpointReached: map['numCheckpointPassed'] ?? 0,
      progressAmount: map['currentProgress'] ?? 0,
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

class ChallengeProgress {
  final String id;
  final String challengeId;
  final int currentProgress;
  final int reachedMilestone;

  ChallengeProgress({
    required this.id,
    required this.challengeId,
    required this.currentProgress,
    required this.reachedMilestone,
  });

  factory ChallengeProgress.fromMap(Map<String, dynamic> map) {
    return ChallengeProgress(
      id: map['_id'] as String? ?? '',
      challengeId: map['challengeId'] as String? ?? '',
      currentProgress: map['currentProgress'] as int? ?? 0,
      reachedMilestone: map['reachedMilestone'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'challengeId': challengeId,
      'currentProgress': currentProgress,
      'reachedMilestone': reachedMilestone,
    };
  }

  @override
  String toString() {
    return 'ChallengeProgress(id: $id, challengeId: $challengeId, currentProgress: $currentProgress, reachedMilestone: $reachedMilestone)';
  }
}