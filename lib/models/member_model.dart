import 'package:tymesavingfrontend/models/user_model.dart';

class Member {
  final User user;
  final DateTime joinedDate;
  final String role; // Member role within a group or organization

  Member({
    required this.user,
    required this.joinedDate,
    required this.role,
  });

  factory Member.fromMap(Map<String, dynamic> json) {
    return Member(
      user: User.fromMap(json['user']),
      joinedDate: DateTime.parse(json['joinedDate']),
      role: json['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'joinedDate': joinedDate.toIso8601String(),
      'role': role,
    };
  }
}