import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';

class Invitation {
  final String invitationId;
  final String code; 
  final String description;
  final InvitationType
      type; 
  final String groupId; 
  final String userFullName;
  final String userUserName;
  // optional
  final String? userId;
  final InvitationStatus? status; 
  SummaryGroup? summaryGroup; 
  

  Invitation.fromMap(Map<String, dynamic> invitation)
      : invitationId = invitation['invitationId'],
        code = invitation['code'],
        description = invitation['description'] ?? "",
        type = InvitationType.fromString(invitation['type']),
        groupId = invitation['groupId'],
        userFullName = invitation['invitedUserFullName'] ?? '',
        userUserName = invitation['invitedUsername'] ?? '',
        // optional
        userId = invitation['userId'] ?? '',
        status = InvitationStatus.fromString(invitation['status'] ?? ''),
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
