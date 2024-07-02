import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';

class Invitation {
  final String id;
  final String code; // 6 character code for the user to enter and join
  final String description;
  final InvitationType type; // is this invitation for SharedBudget or GroupSaving?
  final String groupId; // object ID for the group that this invitation is in
  final List<String> users; // users that have yet to accept the invitation
  final List<String> cancelledUsers; // users that have cancelled the invitation

  Invitation.fromMap(Map<String, dynamic> invitation)
      : id = invitation['_id'],
        code = invitation['code'],
        description = invitation['description'],
        type = InvitationType.fromString(invitation['type']),
        groupId = invitation['groupId'],
        users = List<String>.from(invitation['users'] ?? []),
        cancelledUsers = List<String>.from(invitation['cancelledUsers'] ?? []);

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "code": code,
      "description": description,
      "type": type.toString(),
      "groupId": groupId,
      "users": users,
      "cancelledUsers": cancelledUsers,
    };
  }
}