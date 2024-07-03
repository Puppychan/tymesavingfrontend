import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';

class Invitation {
  final String invitationId;
  final String userId;
  final String code; // 6 character code for the user to enter and join
  final String description;
  final InvitationType
      type; // is this invitation for SharedBudget or GroupSaving?
  final String groupId; // object ID for the group that this invitation is in
  final InvitationStatus status; // status of the invitation

  // optional
  SummaryGroup? summaryGroup; // summary of the budget group
  

  Invitation.fromMap(Map<String, dynamic> invitation)
      : invitationId = invitation['invitationId'],
        userId = invitation['userId'],
        code = invitation['code'],
        description = invitation['description'],
        type = InvitationType.fromString(invitation['type']),
        groupId = invitation['groupId'],
        status = InvitationStatus.fromString(invitation['status']),
        // optional
        summaryGroup = invitation['summaryGroup'] != null
            ? SummaryGroup.fromMap(invitation['summaryGroup'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'invitationId': invitationId,
      'userId': userId,
      'code': code,
      'description': description,
      'type': type.toString(),
      'groupId': groupId,
      'status': status.toString(),
    };
  }
}
