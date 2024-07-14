import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';

class InvitationForm {
  final String description;
  final InvitationType type; // for SharedBudget or GroupSaving?
  final String groupId; // object ID for the group that this invitation is in
  final List<SummaryUser> users;
  

  InvitationForm.fromMap(Map<String, dynamic> invitation)
      : description = invitation['description'],
        type = invitation['type'],
        groupId = invitation['groupId'],
        users = invitation['users'];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'type': type.toString(),
      'groupId': groupId,
      'users': users.map((e) => e.id),
    };
  }
}
