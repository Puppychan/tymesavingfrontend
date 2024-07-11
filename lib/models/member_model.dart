import 'package:tymesavingfrontend/models/summary_user_model.dart';

class Member {
  final SummaryUser user;
  final String joinedDate;
  final String role; // Member role within a group or organization

  Member({
    required this.user,
    required this.joinedDate,
    required this.role,
  });

  factory Member.fromMap(Map<String, dynamic> json) {
    return Member(
      user: SummaryUser.fromMap(json['user']),
      joinedDate: json['joinedDate'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'joinedDate': joinedDate,
      'role': role,
    };
  }
}